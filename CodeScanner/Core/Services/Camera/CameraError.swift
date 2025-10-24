//
//  CameraError.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 22.10.2025.
//

import Foundation

enum CameraError: Error {
    case cameraUnavailable
    case cannotAddInput
    case cannotAddOutput
    case createCaptureInput(Error)
    case deniedAuthorization
    case restrictedAuthorization
    case unknownAuthorization
}

extension CameraError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "Camera unavailable"
        case .cannotAddInput:
            return "Cannot add capture input to session"
        case .cannotAddOutput:
            return "Cannot add output to session"
        case .createCaptureInput(let error):
            return "Error creating capture input: \(error.localizedDescription)"
        case .deniedAuthorization:
            return "Camera access denied"
        case .restrictedAuthorization:
            return "Camera access restricted"
        case .unknownAuthorization:
            return "Unknown camera authorization status"
        }
    }
}
