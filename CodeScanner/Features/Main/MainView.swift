//
//  MainView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import SwiftUI

struct MainView: View {
    @Environment(\.diContainer) private var container
    @StateObject private var coordinator = TabCoordinator()
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            ForEach(TabItem.allCases) { tab in
                coordinator.makeTabView(for: tab, container: container)
                    .tabItem {
                        Label(tab.title, systemImage: tab.icon)
                    }
                    .tag(tab)
            }
        }
    }
}

#Preview {
    let container = AppDependencies.configure()
    MainView()
        .environment(\.diContainer, container)
}
