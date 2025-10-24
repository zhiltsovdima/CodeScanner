//
//  CodeRepository.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import CoreData

protocol CodeRepository {
    func save(_ item: ScannedItem) async throws
    func fetchAll() async throws -> [ScannedItem]
    func delete(id: String) async throws
    func fetch(byRawCode rawCode: String) async throws -> ScannedItem?
    func fetch(byID id: String) async throws -> ScannedItem?
    func update(_ item: ScannedItem) async throws 
}

final class CoreDataCodeRepository {
    private let storage: StorageStackInterface
    
    init(storage: StorageStackInterface) {
        self.storage = storage
    }
}

// MARK: - Private Helpers
private extension CoreDataCodeRepository {
    
    // MARK: - Write (Save or Update)
    func performWrite<T>(
        context: NSManagedObjectContext,
        operation: @escaping (NSManagedObjectContext) throws -> T
    ) async throws -> T {
        try await context.perform {
            let result = try operation(context)
            try self.storage.save(context: context)
            return result
        }
    }
    
    // MARK: - Write (Void)
    func performWriteVoid(
        context: NSManagedObjectContext,
        operation: @escaping (NSManagedObjectContext) throws -> Void
    ) async throws {
        try await context.perform {
            try operation(context)
            try self.storage.save(context: context)
        }
    }
    
    // MARK: - Fetch
    func performFetch<T>(
        context: NSManagedObjectContext,
        operation: @escaping (NSManagedObjectContext) throws -> [T]
    ) async throws -> [T] {
        try await context.perform {
            try operation(context)
        }
    }
    
    // MARK: - Remove
    func performRemove(
        context: NSManagedObjectContext,
        entityName: String,
        id: String
    ) async throws {
        try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            let results = try context.fetch(request)
            if let entity = results.first {
                context.delete(entity)
                if context.hasChanges {
                    try self.storage.save(context: context)
                }
            }
        }
    }
}

extension CoreDataCodeRepository: CodeRepository {
    
    func save(_ item: ScannedItem) async throws {
        try await performWriteVoid(context: storage.backgroundContext()) { ctx in
            let entity = CDScannedItem(context: ctx)
            entity.id = item.id
            entity.scanDate = item.scanDate
            entity.rawCode = item.rawCode
            
            switch item {
            case .qr:
                entity.type = "qr"
                entity.productData = nil
            case .product(let vm):
                entity.type = "product"
                entity.productData = try JSONEncoder().encode(vm)
            }
        }
    }
    
    func update(_ item: ScannedItem) async throws {
        try await performWriteVoid(context: storage.backgroundContext()) { ctx in
            let request: NSFetchRequest<CDScannedItem> = CDScannedItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", item.id)
            request.fetchLimit = 1

            if let existingEntity = try ctx.fetch(request).first {
                existingEntity.name = item.displayName
            } else {
                let entity = CDScannedItem(context: ctx)
                entity.id = item.id
                entity.scanDate = item.scanDate
                entity.rawCode = item.rawCode
                entity.name = item.displayName
                
                switch item {
                case .qr:
                    entity.type = "qr"
                    entity.productData = nil
                case .product(let vm):
                    entity.type = "product"
                    entity.productData = try JSONEncoder().encode(vm)
                }
            }
        }
    }
    
    func fetchAll() async throws -> [ScannedItem] {
        try await performFetch(context: storage.uiContext) { ctx in
            let request: NSFetchRequest<CDScannedItem> = CDScannedItem.fetchRequest()
            let entities = try ctx.fetch(request)
            return entities.compactMap { $0.toScannedItem() }
        }
    }

    func delete(id: String) async throws {
        try await performRemove(context: storage.backgroundContext(), entityName: "CDScannedItem", id: id)
    }

    func fetch(byRawCode rawCode: String) async throws -> ScannedItem? {
        try await performFetch(context: storage.uiContext) { ctx in
            let request: NSFetchRequest<CDScannedItem> = CDScannedItem.fetchRequest()
            request.predicate = NSPredicate(format: "rawCode == %@", rawCode)
            request.fetchLimit = 1
            return try ctx.fetch(request).first?.toScannedItem().map { [$0] } ?? []
        }.first
    }

    func fetch(byID id: String) async throws -> ScannedItem? {
        try await performFetch(context: storage.uiContext) { ctx in
            let request: NSFetchRequest<CDScannedItem> = CDScannedItem.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            request.fetchLimit = 1
            return try ctx.fetch(request).first?.toScannedItem().map { [$0] } ?? []
        }.first
    }
}
