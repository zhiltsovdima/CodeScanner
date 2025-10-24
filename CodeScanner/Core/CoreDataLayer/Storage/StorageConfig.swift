//
//  StorageConfig.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import CoreData

struct StorageConfig {
    let modelName: String
    let inMemory: Bool
    let mergePolicy: NSMergePolicy
    
    static let defaultConfig = StorageConfig(
        modelName: "CodeScanner",
        inMemory: false,
        mergePolicy: .mergeByPropertyObjectTrump
    )
    
    #if DEBUG
    static let testConfig = StorageConfig(
        modelName: "CodeScanner",
        inMemory: true,
        mergePolicy: .mergeByPropertyObjectTrump
    )
    #endif
}
