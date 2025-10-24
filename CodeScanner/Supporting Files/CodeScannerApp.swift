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
    
    let container: DIContainer = AppDependencies.configure()
    let coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootView(coordinator: coordinator)
                .environment(\.diContainer, container)
                .task {
                    await coordinator.start()
                }
        }
    }
}
