//
//  FoodFactsAPI.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

enum FoodFactsAPI: Endpoint {
    case getProductsData(String)
    
    var scheme: String { Self.defaultScheme }
    var host: String { Environment.current.host }
    var path: String {
        switch self {
        case .getProductsData(let code):
            "/api/v2/product/\(code)"
        }
    }
    
    var method: HTTPMethod { .get }
    var headers: [String : String]? {
        switch Environment.current {
        case .test:
            return ["Authorization": "Basic \(Data("off:off".utf8).base64EncodedString())"]
        case .production:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}

// MARK: - Environment
private extension FoodFactsAPI {
    enum Environment {
        case test
        case production
        
        static var current: Self {
            AppBundle.isReleaseBundle ? .production : .test
        }
        
        var host: String {
            switch self {
            case .test:
                return "world.openfoodfacts.net"
            case .production:
                return "world.openfoodfacts.org"
            }
        }
    }
}
