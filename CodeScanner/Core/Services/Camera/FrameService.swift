//
//  FrameService.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import AVFoundation
import Combine
import Foundation

protocol FrameServiceProtocol {
    
}

final class FrameService: NSObject, ObservableObject, FrameServiceProtocol {
    
    @Published var qrCodeDetected: String?
    
    var shouldCaptureQrCode = true
    private let qrCodeQueue = DispatchQueue(label: "qr.output.queue")
    
    private let cameraService: CameraServiceProtocol
    
    init(cameraService: CameraServiceProtocol) {
        self.cameraService = cameraService
        super.init()
        setupQRCodeDetection()
    }
    
    private func setupQRCodeDetection() {
        cameraService.setMetadataDelegate(self, queue: qrCodeQueue)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension FrameService: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard shouldCaptureQrCode,
              let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue else { return }
        
        DispatchQueue.main.async {
            self.qrCodeDetected = stringValue
        }
    }
}

