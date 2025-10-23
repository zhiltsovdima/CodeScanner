//
//  RootView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import SwiftUI

struct RootView: View {
    @Environment(\.diContainer) private var container
    
    var body: some View {
        let coordinator = container.resolve(AppCoordinator.self)
        Group {
            switch coordinator.currentFlow {
            case .main:
                ScannerView(viewModel: container.resolve(ScannerViewModel.self))
            }
        }
        .animation(.default, value: coordinator.currentFlow)
    }
}

#Preview {
    let container = AppDependencies.configure()
    RootView()
        .environment(\.diContainer, container)
}
