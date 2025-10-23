//
//  NetworkProvider.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

typealias NetworkResponse = (Data, URLResponse)

enum RequestOperation {
    case send
    case upload(Data)
}

protocol NetworkProvider {
    func perform(request: URLRequest, type: RequestOperation) async throws -> NetworkResponse
}

final class URLSessionProvider: NetworkProvider {
    
    func perform(request: URLRequest, type: RequestOperation) async throws -> NetworkResponse {
        switch type {
        case .send:
            return try await send(request: request)
        case .upload(let bodyData):
            return try await upload(request: request, from: bodyData)
        }
    }
    
    private func send(request: URLRequest) async throws -> NetworkResponse {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, response)
        } catch {
            let netError = NetworkError.provider(ProviderFailure(from: error))
            NetworkLogger.log(error: netError)
            throw netError
        }
    }
    
    private func upload(request: URLRequest, from bodyData: Data) async throws -> NetworkResponse {
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: bodyData)
            return (data, response)
        } catch {
            let netError = NetworkError.provider(ProviderFailure(from: error))
            NetworkLogger.log(error: netError)
            throw netError
        }
    }
}
