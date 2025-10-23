//
//  ProductsService.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

protocol ProductServiceProtocol: AnyObject {
    func fetchProductsData(code: String) async throws -> ProductFactsResponse
}

final class ProductsService: ProductServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProductsData(code: String) async throws -> ProductFactsResponse {
        let request = try FoodFactsAPI
            .getProductsData(code)
            .makeRequest()
        
        let config = RequestConfig(request: request, type: .send, validator: DefaultResponseValidator())
        let handler = JSONResponseHandler<ProductFactsResponse>()
        
        let response = try await networkClient.fetch(config, with: handler)
        return response
    }
}
