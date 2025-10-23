//
//  ProviderFailure.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

enum ProviderFailure: Error {
    case noInternet
    case timeout
    case badURL
    case connectionLost
    case sslError
    case cancelled
    case unknown

    init(from error: Error) {
        guard let error = error as? URLError else {
            self = .unknown
            return
        }
        switch error.code {
        case .notConnectedToInternet:
            self = .noInternet
        case .timedOut:
            self = .timeout
        case .badURL:
            self = .badURL
        case .networkConnectionLost:
            self = .connectionLost
        case .secureConnectionFailed:
            self = .sslError
        case .cancelled:
            self = .cancelled
        default:
            self = .unknown
        }
    }

    var errorCode: Int {
        switch self {
        case .noInternet:
            return URLError.notConnectedToInternet.rawValue
        case .timeout:
            return URLError.timedOut.rawValue
        case .badURL:
            return URLError.badURL.rawValue
        case .connectionLost:
            return URLError.networkConnectionLost.rawValue
        case .sslError:
            return URLError.secureConnectionFailed.rawValue
        case .cancelled:
            return URLError.cancelled.rawValue
        case .unknown:
            return (self as NSError).code
        }
    }
    
    var message: String {
        let errorMessage: String
        switch self {
        case .noInternet:
            errorMessage = "No internet connection"
        case .timeout:
            errorMessage = "Request timed out"
        case .badURL:
            errorMessage = "Invalid URL"
        case .connectionLost:
            errorMessage = "Network connection lost"
        case .sslError:
            errorMessage = "SSL connection error"
        case .cancelled:
            errorMessage = "Request was cancelled"
        case .unknown:
            errorMessage = self.localizedDescription
        }
        return "[\(errorCode)] \(errorMessage)"
    }
}
