//
//  NetworkError.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

enum NetworkError: Error {
    case provider(ProviderFailure)
    
    case client(statusCode: Int)
    case server(statusCode: Int)
    case unexpectedResponse(statusCode: Int)
    
    case invalidURL
    case invalidResponse
    case decoding
    
    var errorCode: Int {
        switch self {
        case .provider(let failure):
            return failure.errorCode
        case .client(let code), .server(let code), .unexpectedResponse(let code):
            return code
        default:
            return -1
        }
    }

    var message: String {
        switch self {
        case .provider(let failure):
            return failure.message
        case .client(let code):
            return "[\(code)] Client error"
        case .server(let code):
            return "[\(code)] Server error"
        case .unexpectedResponse(let code):
            return "[\(code)] Unexpected response"
        case .invalidURL:
            return "Invalid URL"
        case .decoding:
            return "Failed to decode response"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}
