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
    @Published var isTorchOn = false
    @Published var currentScannedItem: ScannedItem?
    @Published var isLoading: Bool = false
    
    @Published var alertMessage: String?
    @Published var showingAlert: Bool = false
    
    @Published var showingCameraSettingsAlert: Bool = false
    @Published var cameraErrorMessage: String?
    
    private let frameService: FrameService
    private let cameraService: CameraService
    private let productsService: ProductServiceProtocol
    private let codeRepo: CodeRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    var frameSession: AVCaptureSession {
        cameraService.session
    }
    
    init(container: DIContainer) {
        self.cameraService = container.resolve(CameraService.self)
        self.frameService = container.resolve(FrameService.self)
        self.productsService = container.resolve(ProductServiceProtocol.self)
        self.codeRepo = container.resolve(CodeRepository.self)
        setupBindings()
    }
    
    private func setupBindings() {
        frameService.$code
            .compactMap { $0 }
            .removeDuplicates { prev, next in
                prev.0 == next.0
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] codeTuple in
                guard let self = self else { return }
                let (code, type) = codeTuple
                Task { await self.handleScannedCode(code: code, type: type) }
            }
            .store(in: &cancellables)
        
        cameraService.$showingSettingsAlert
            .receive(on: DispatchQueue.main)
            .assign(to: &$showingCameraSettingsAlert)
        
        cameraService.$error
            .compactMap { $0?.localizedDescription }
            .receive(on: DispatchQueue.main)
            .assign(to: &$cameraErrorMessage)
    }

    @MainActor
    private func handleScannedCode(code: String, type: ScannedCodeType) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let existingItem = try await codeRepo.fetch(byRawCode: code) {
                currentScannedItem = existingItem
                return
            }
            
            let newItem: ScannedItem
            switch type {
            case .qr:
                let qrContent = QRCodeContent(rawValue: code, date: Date())
                newItem = .qr(qrContent)
                
            case .barcode:
                let productData = try await productsService.fetchProductsData(code: code)
                let productVM = ProductDetailViewModel(from: productData)
                newItem = .product(productVM)
            }
            
            try await codeRepo.save(newItem)
            currentScannedItem = newItem
            
        } catch let netError as NetworkError {
            alertMessage = netError.message
            showingAlert = true
        } catch {
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }

    
    func onAppear() {
        guard cameraService.status == .unconfigured else { return }
        cameraService.configure()
    }
    
    func onDisappear() {
        cameraService.stopSession()
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
