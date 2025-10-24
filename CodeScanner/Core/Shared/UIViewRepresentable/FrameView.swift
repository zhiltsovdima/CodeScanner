//
//  FrameView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import SwiftUI
import AVFoundation

struct FrameView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> PreviewUIView {
        PreviewUIView(session: session)
    }
    
    func updateUIView(_ uiView: PreviewUIView, context: Context) {
    }
}

class PreviewUIView: UIView {
    let previewLayer: AVCaptureVideoPreviewLayer
    
    init(session: AVCaptureSession) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init(frame: .zero)
        self.previewLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(previewLayer)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = self.bounds
    }
}
