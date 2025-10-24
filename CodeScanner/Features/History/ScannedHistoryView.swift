//
//  ScannedHistoryView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

struct ScannedHistoryView: View {
    @ObservedObject var viewModel: ScannedHistoryViewModel
    @State private var editingItem: ScannedItem?
    @State private var editedName: String = ""

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.scannedItems.isEmpty {
                    emptyState
                } else {
                    itemsList
                }
            }
            .navigationTitle("Scan History")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $editingItem) { item in
            VStack(spacing: 20) {
                Text("Edit Name")
                    .font(.headline)
                
                TextField("Enter name", text: $editedName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Save") {
                    Task {
                        await viewModel.updateDisplayName(for: item, newName: editedName)
                        editingItem = nil
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Button("Cancel") {
                    editingItem = nil
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
    
    private var itemsList: some View {
        List {
            ForEach(viewModel.scannedItems) { item in
                NavigationLink {
                    destinationView(for: item)
                } label: {
                    ScannedItemCard(item: item)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        Task { await viewModel.deleteItem(item: item) }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        editedName = item.displayName ?? item.rawCode
                        editingItem = item
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.updateItems()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 48))
            Text("No scans yet")
                .font(.headline)
            Text("Scan a QR code or barcode to see it here.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func destinationView(for item: ScannedItem) -> some View {
        switch item {
        case .qr(let content):
            QrCodeDetailView(content: content)
        case .product(let vm):
            ProductDetailView(viewModel: vm)
        }
    }
}

#Preview {
    let container = AppDependencies.configure()
    ScannedHistoryView(
        viewModel: container.resolve(ScannedHistoryViewModel.self)
    )
}
