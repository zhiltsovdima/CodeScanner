//
//  ResponseValidator.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

protocol ResponseValidator: Sendable {
    func validate(_ response: HTTPURLResponse, data: Data) throws
}

struct DefaultResponseValidator: ResponseValidator {
    func validate(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 400...499:
            throw NetworkError.client(statusCode: response.statusCode)
        case 500...599:
            throw NetworkError.server(statusCode: response.statusCode)
        default:
            throw NetworkError.unexpectedResponse(statusCode: response.statusCode)
        }
    }
}
