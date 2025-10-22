//
//  ScannerViewModel.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import AVFoundation
import SwiftUI
import Combine

final class ScannerViewModel: ObservableObject {
    @Published var qrCode: String?
    @Published var isTorchOn = false
    
    private let frameService: FrameService
    private let cameraService: CameraService
    
    private var cancellables = Set<AnyCancellable>()
    
    var frameSession: AVCaptureSession {
        cameraService.session
    }
    
    init(cameraService: CameraService, frameService: FrameService) {
        self.cameraService = cameraService
        self.frameService = frameService
        setupBindings()
    }
    
    private func setupBindings() {
        frameService.$qrCodeDetected
            .receive(on: RunLoop.main)
            .assign(to: &$qrCode)
    }
    
    func onAppear() {
        cameraService.configure()
    }
    
    func toggleTorch() {
        do {
            try cameraService.toggleTorch()
            isTorchOn = cameraService.isTorchOn
        } catch {
            print("Torch error: \(error.localizedDescription)")
        }
    }
}
