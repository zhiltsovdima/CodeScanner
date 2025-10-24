//
//  StorageStack.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import CoreData

/// Многоуровневая реализация стека CoreData для управления контекстами
///
/// - Суть:
///   - Изменения от дочерних контекстов стекаются в родительский контекст `writeContext`а затем в базу
///   - `writeContext` (private queue): Родительский контекст, единая точка записи в базу
///   - `uiContext` (main queue): Дочерний, для чтения и UI-операций
///   - `backgroundContext` (private queue): Дочерний, для фоновой записи
///
/// - Особенности:
///   - Повышает производительность при многопоточности
///   - Эффективно использовать в больших проектах с активным UI и фоновыми операциями

// MARK: Interface

protocol StorageStackInterface {
    var uiContext: NSManagedObjectContext { get }
    func backgroundContext() -> NSManagedObjectContext
    func save(context: NSManagedObjectContext) throws
}

final class StorageStack: StorageStackInterface {
    private let container: NSPersistentContainer
    
    var uiContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init(config: StorageConfig) {
        container = NSPersistentContainer(name: config.modelName)
        
        if config.inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        container.viewContext.mergePolicy = config.mergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = container.viewContext.mergePolicy
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func save(context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        
        try context.performAndWait {
            try context.save()
        }
    }
}
