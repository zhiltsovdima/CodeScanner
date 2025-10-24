//
//  ScannedResultsView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

struct ScannedResultsView: View {
    @ObservedObject var viewModel: ScannerViewModel
    @State private var selectedItem: ScannedItem?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            } else {
                VStack(spacing: 16) {
                    if let item = viewModel.currentScannedItem {
                        ScannedResultCard(item: item)
                            .frame(width: 280)
                            .onTapGesture {
                                selectedItem = item
                            }
                    } else {
                        emptyState
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(item: $selectedItem) { item in
            switch item {
            case .qr(let content):
                QrCodeDetailView(content: content)
            case .product(let vm):
                ProductDetailView(viewModel: vm)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.5))
            
            Text("Scan a code to see results")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            
            Text("Point your camera at a QR code or barcode")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    let container = AppDependencies.configure()
    ScannedResultsView(
        viewModel: container.resolve(ScannerViewModel.self)
    )
}
