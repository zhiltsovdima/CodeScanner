//
//  TabCoordinator.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Combine
import SwiftUI

//MARK: - TabItem
enum TabItem: Int, Hashable, Identifiable, CaseIterable {
    case scanner
    case history
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .scanner: return "Scanner"
        case .history: return "History"
        }
    }
    
    var icon: String {
        switch self {
        case .scanner: return "qrcode.viewfinder"
        case .history: return "clock"
        }
    }
}

//MARK: - TabCoordinator
final class TabCoordinator: ObservableObject {
    @Published var selectedTab: TabItem = .scanner

    private let scannerCoordinator = ScannerCoordinator()
    private let historyCoordinator = HistoryCoordinator()
    
    func makeTabView(for tab: TabItem, container: DIContainer) -> AnyView {
        switch tab {
        case .scanner:
            return AnyView(
                ScannerView(
                    coordinator: self.scannerCoordinator,
                    viewModel: container.resolve(ScannerViewModel.self)
                )
            )
        case .history:
            let historyVM = container.resolve(ScannedHistoryViewModel.self)
            return AnyView(
                ScannedHistoryView(
                    viewModel: historyVM
                )
                .task(id: selectedTab) {
                    if self.selectedTab == .history {
                        await historyVM.updateItems()
                    }
                }
            )
        }
    }
}
