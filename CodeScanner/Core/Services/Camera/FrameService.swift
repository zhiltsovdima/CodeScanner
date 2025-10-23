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
    
    @Published var qrCode: String?
    @Published var barcode: String?

    var shouldCaptureCode = true
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
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard shouldCaptureCode,
              let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = metadataObject.stringValue else { return }
        
        DispatchQueue.main.async {
            switch metadataObject.type {
            case .qr:
                print("QR code: \(stringValue)")
                self.qrCode = stringValue
            case .ean8, .ean13, .code128, .code39, .code93, .pdf417, .aztec, .dataMatrix, .itf14, .upce:
                print("Barcode: \(metadataObject.type.rawValue) → \(stringValue)")
                self.barcode = stringValue
            default:
                print("Other code: \(metadataObject.type.rawValue) → \(stringValue)")
            }
        }
    }
}
