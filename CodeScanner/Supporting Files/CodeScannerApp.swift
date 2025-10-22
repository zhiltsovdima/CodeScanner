//
//  CodeScannerApp.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import SwiftUI

@main
struct CodeScannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    let container: DIContainer
    let coordinator: AppCoordinator
    
    init() {
        self.container = AppDependencies.configure()
        self.coordinator = container.resolve(AppCoordinator.self)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.diContainer, container)
                .task {
                    await coordinator.start()
                }
        }
    }
}
