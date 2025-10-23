//
//  RootView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import SwiftUI

struct RootView: View {
    @StateObject var coordinator: AppCoordinator
    
    var body: some View {
        Group {
            switch coordinator.currentFlow {
            case .main:
                MainView()
            }
        }
        .animation(.default, value: coordinator.currentFlow)
    }
}

#Preview {
    let container = AppDependencies.configure()
    RootView(coordinator: AppCoordinator())
        .environment(\.diContainer, container)
}
