//
//  ScannedHistoryViewModel.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import Combine
import Foundation

final class ScannedHistoryViewModel: ObservableObject {
    @Published var scannedItems: [ScannedItem] = []
    
    private let codeRepo: CodeRepository
    
    init(codeRepo: CodeRepository) {
        self.codeRepo = codeRepo
    }
    
    func updateItems() async {
        print("update")
        await fetchScannedItems()
    }
    
    @MainActor
    func fetchScannedItems() async {
        do {
            let items = try await codeRepo.fetchAll()
            self.scannedItems = items.sorted { $0.scanDate > $1.scanDate }
        } catch {
            print("Failed to fetch scanned items: \(error)")
        }
    }
    
    @MainActor
    func deleteItem(item: ScannedItem) async {
        do {
            try await codeRepo.delete(id: item.id)
            if let index = scannedItems.firstIndex(where: { $0.id == item.id }) {
                scannedItems.remove(at: index)
            }
        } catch {
            print("Failed to delete item: \(error)")
        }
    }
    
    @MainActor
    func updateDisplayName(for item: ScannedItem, newName: String) async {
        var updatedItem = item
        switch item {
        case .qr(var content):
            content.displayName = newName
            updatedItem = .qr(content)
        case .product(let vm):
            vm.displayName = newName
            updatedItem = .product(vm)
        }
        
        do {
            try await codeRepo.update(updatedItem)
            if let index = scannedItems.firstIndex(where: { $0.id == item.id }) {
                scannedItems[index] = updatedItem
            }
        } catch {
            print("Failed to update display name: \(error)")
        }
    }

}

