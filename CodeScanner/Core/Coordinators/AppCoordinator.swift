//
//  AppCoordinator.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import Combine
import Foundation

protocol Coordinator: ObservableObject {
    associatedtype Route
    var currentFlow: Route { get set }
    func start() async
    func navigate(to route: Route) async
}

extension Coordinator {
    @MainActor
    func navigate(to route: Route) async {
        currentFlow = route
    }
}

// MARK: - AppCoordinator
final class AppCoordinator: Coordinator {
    
    enum Flow: Equatable {
        case main
    }
    
    @Published var currentFlow: Flow = .main
    
    func start() async {}

}
