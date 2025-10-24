//
//  NetworkClient.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

struct RequestConfig {
    let request: URLRequest
    let type: RequestOperation
    let validator: ResponseValidator
    
    init(request: URLRequest, type: RequestOperation, validator: ResponseValidator) {
        self.request = request
        self.type = type
        self.validator = validator
    }
    
    init(request: URLRequest) {
        self.request = request
        self.type = .send
        self.validator = DefaultResponseValidator()
    }
}

protocol NetworkClient {
    func fetch<T, Handler: ResponseHandler>(
        _ config: RequestConfig,
        with handler: Handler
    ) async throws -> Handler.Output where Handler.Output == T
}

// MARK: - DefaultNetworkClient

final class DefaultNetworkClient: NetworkClient {
    
    private let provider: NetworkProvider

    init(provider: NetworkProvider) {
        self.provider = provider
    }

    func fetch<T, Handler: ResponseHandler>(
        _ config: RequestConfig,
        with handler: Handler
    ) async throws -> Handler.Output where Handler.Output == T {
        NetworkLogger.log(request: config.request)
        let (data, response) = try await provider.perform(request: config.request, type: config.type)

        NetworkLogger.log(response: response, data: data)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        try config.validator.validate(httpResponse, data: data)
        return try handler.handle(data: data, response: httpResponse)
    }
}
