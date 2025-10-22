//
//  ScannerView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import SwiftUI
import AVFoundation

struct ScannerView: View {
    @StateObject var viewModel: ScannerViewModel
    
    var body: some View {
        ZStack {
            FrameView(session: viewModel.frameSession)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Button(action: {
                    viewModel.toggleTorch()
                }) {
                    Text(viewModel.isTorchOn ? "Torch On" : "Torch Off")
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    let container = DIContainer()
    ScannerView(viewModel: container.resolve(ScannerViewModel.self))
}
