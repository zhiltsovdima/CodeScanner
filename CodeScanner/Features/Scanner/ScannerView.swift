//
//  ScannerView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import SwiftUI
import AVFoundation

struct ScannerView: View {
    @StateObject var coordinator: ScannerCoordinator
    @StateObject var viewModel: ScannerViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    cameraView
                        .frame(height: geometry.size.height / 2.5)
                    
                    ScannedResultsView(viewModel: viewModel)
                        .padding(.bottom)
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
        .alert(viewModel.alertMessage ?? "", isPresented: $viewModel.showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Camera Access Required", isPresented: $viewModel.showingCameraSettingsAlert) {
            Button("Open Settings") { openSettings() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Please allow camera access in Settings to scan codes.")
        }
    }
    
    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    var cameraView: some View {
        ZStack {
            FrameView(session: viewModel.frameSession)
                .edgesIgnoringSafeArea(.all)
            Image(systemName: "camera")
                .foregroundStyle(Color.white)
                .opacity(0.3)
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 2)
                .opacity(0.3)
                .padding(60)
            VStack {
                Spacer()
                HStack {
                    flashlightButton
                    Spacer()
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    var flashlightButton: some View {
        if #available(iOS 26.0, *) {
            Button {
                viewModel.toggleTorch()
            } label: {
                Image(systemName: viewModel.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                    .foregroundStyle(viewModel.isTorchOn ? .yellow : .black)
            }
            .frame(width: 40)
            .clipShape(Circle())
            .buttonStyle(.glass)
        } else {
            Button {
                viewModel.toggleTorch()
            } label: {
                Image(systemName: viewModel.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                    .foregroundStyle(viewModel.isTorchOn ? .yellow : .black)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
        }
    }
}

#Preview {
    let container = AppDependencies.configure()
    ScannerView(
        coordinator: ScannerCoordinator(),
        viewModel: container.resolve(ScannerViewModel.self)
    )
}
