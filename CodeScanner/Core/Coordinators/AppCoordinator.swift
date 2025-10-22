//
//  AppCoordinator.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import Combine
import Foundation

enum AppFlow: Equatable {
    case main
}

protocol Coordinator: ObservableObject {
    associatedtype Route
    func start()
    func navigate(to route: Route)
}

// MARK: - AppCoordinator
class AppCoordinator: ObservableObject {
    @Published var currentFlow: AppFlow = .main
    
    func start() async {

    }
    
    @MainActor
    func showMainFlow() async {
        currentFlow = .main
    }
}
