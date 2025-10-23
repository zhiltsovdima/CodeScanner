//
//  CameraService.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import AVFoundation
import Combine

protocol CameraServiceProtocol {
    var error: CameraError? { get }
    var isTorchOn: Bool { get }
    
    func setMetadataDelegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue)
    func configure()
    func toggleTorch() throws
}

final class CameraService: ObservableObject, CameraServiceProtocol {
    
    enum Status {
        case unconfigured, configured, unauthorized, failed
    }
    
    @Published private(set) var error: CameraError?
    @Published private(set) var status: Status = .unconfigured

    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private(set) var session = AVCaptureSession()
    
    private var metaDataOutput = AVCaptureMetadataOutput()

    private var currentCamera: AVCaptureDevice? {
        session.inputs
            .compactMap { ($0 as? AVCaptureDeviceInput)?.device }
            .first
    }
    
    // MARK: - Auth
    private func checkAuthorization(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        case .restricted:
            setError(.restrictedAuthorization)
            completion(false)
        case .denied:
            setError(.deniedAuthorization)
            completion(false)
        @unknown default:
            setError(.unknownAuthorization)
            completion(false)
        }
    }
    
    // MARK: - Configuration
    func configure() {
        checkAuthorization { [weak self] granted in
            guard granted, let self else { return }
            self.sessionQueue.async {
                self.configureCaptureSession()
                self.session.startRunning()
            }
        }
    }
    
    func setMetadataDelegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.metaDataOutput.setMetadataObjectsDelegate(delegate, queue: queue)
        }
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else { return }
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        do {
            try configureInput()
            try configureMetadataOutput()
            status = .configured
        } catch let cameraError as CameraError {
            setError(cameraError)
            status = .failed
        } catch {
            setError(.createCaptureInput(error))
            status = .failed
        }
    }

    private func configureInput() throws {
        guard let camera = AVCaptureDevice.default(for: .video) else {
            throw CameraError.cameraUnavailable
        }
        
        let input = try AVCaptureDeviceInput(device: camera)
        
        guard session.canAddInput(input) else {
            throw CameraError.cannotAddInput
        }
        
        session.addInput(input)
    }

    private func configureMetadataOutput() throws {
        guard session.canAddOutput(metaDataOutput) else {
            throw CameraError.cannotAddOutput
        }

        session.addOutput(metaDataOutput)
        
        let supportedTypes: [AVMetadataObject.ObjectType] = [
            .qr,
            .ean8,
            .ean13,
            .code128,
            .code39,
            .code93,
            .pdf417,
            .aztec,
            .dataMatrix,
            .itf14,
            .upce
        ].filter { metaDataOutput.availableMetadataObjectTypes.contains($0) }

        metaDataOutput.metadataObjectTypes = supportedTypes
    }
    
    // MARK: - Error handling
    private func setError(_ error: CameraError) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
}

// MARK: - Torch
extension CameraService {
    var isTorchOn: Bool {
        currentCamera?.torchMode == .on
    }
    
    func toggleTorch() throws {
        guard let device = currentCamera, device.hasTorch else {
            throw CameraError.cameraUnavailable
        }
        try device.lockForConfiguration()
        defer { device.unlockForConfiguration() }
        device.torchMode = device.torchMode == .on ? .off : .on
    }
}
