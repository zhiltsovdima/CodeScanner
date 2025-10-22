//
//  AppDependencies.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import SwiftUI

final class AppDependencies {
    
    static func configure() -> DIContainer {
        let container = DIContainer()
        
        container.register(AppCoordinator.self, scope: .singleton) { _ in
            AppCoordinator()
        }
        
        return container
    }
}

// MARK: - EnvironmentKey
private struct DIContainerKey: EnvironmentKey {
    static let defaultValue: DIContainer = DIContainer()
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
