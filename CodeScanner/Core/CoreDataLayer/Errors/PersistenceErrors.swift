//
//  PersistenceErrors.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import Foundation

enum PersistenceError: Error {
    case storage(Error)
    case invalidEntity
    case fetchFailed
    case saveFailed
    case updateFailed
    case deleteFailed
    case contextNotFound
    case decoding
    case entityNotFound
    
    var message: String {
        switch self {
        case .storage(let failure):
            return failure.localizedDescription
        case .invalidEntity:
            return "Invalid entity"
        case .fetchFailed:
            return "Failed to fetch data"
        case .saveFailed:
            return "Failed to save data"
        case .updateFailed:
            return "Failed to update data"
        case .deleteFailed:
            return "Failed to delete data"
        case .contextNotFound:
            return "Context not found"
        case .decoding:
            return "Failed to decode entity"
        case .entityNotFound:
            return "Entity not found"
        }
    }
}
