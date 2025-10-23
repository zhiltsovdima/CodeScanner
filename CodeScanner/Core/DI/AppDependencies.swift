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
        
        container.register(CameraService.self, scope: .singleton) { _ in
            CameraService()
        }
        
        container.register(FrameService.self, scope: .singleton) { container in
            FrameService(cameraService: container.resolve(CameraService.self))
        }
        
        container.register(NetworkProvider.self, scope: .singleton) { _ in
            URLSessionProvider()
        }
        
        container.register(NetworkClient.self, scope: .singleton) { container in
            DefaultNetworkClient(provider: container.resolve(NetworkProvider.self))
        }
        
        container.register(ProductServiceProtocol.self, scope: .singleton) { container in
            ProductsService(networkClient: container.resolve(NetworkClient.self))
        }
        
        container.register(ScannerViewModel.self) { container in
            ScannerViewModel(
                cameraService: container.resolve(CameraService.self),
                frameService: container.resolve(FrameService.self),
                productsService: container.resolve(ProductServiceProtocol.self)
            )
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
