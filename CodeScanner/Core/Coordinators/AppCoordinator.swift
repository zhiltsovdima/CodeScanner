//
//  AppCoordinator.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import Combine
import Foundation

// MARK: - AppCoordinator
final class AppCoordinator: ObservableObject {
    
    enum Flow: Equatable {
        case main
    }
    
    @Published var currentFlow: Flow = .main
    
    func start() async {}

}
