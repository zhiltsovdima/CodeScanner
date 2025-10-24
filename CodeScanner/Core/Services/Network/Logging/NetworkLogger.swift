//
//  NetworkLogger.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation
import OSLog

struct NetworkLogger {
    
    enum LoggingMode {
        /// No request/response logs, only critical errors
        case minimal
        /// Logs requests (URL, method), responses (URL, status code), and errors
        case standard
        /// Includes request headers, body, and full response data
        case verbose
    }
    
    private static let logger = Logger(subsystem: "com.zhiltsovdima.CodeScanner", category: "network")

    private static let mode: LoggingMode = .standard

    static func log(request: URLRequest) {
        guard mode != .minimal else { return }
        
        let url = get(url: request.url)
        
        logger.info("🟡 [NetworkLogger] Request: \(url, privacy: .public)")
        logger.info("Method: \(request.httpMethod ?? "-", privacy: .public)")

        if mode == .verbose {
            if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
                logger.debug("Headers: \(headers, privacy: .private)")
            }
            if let body = request.httpBody, let jsonString = String(data: body, encoding: .utf8) {
                logger.debug("Body: \(jsonString, privacy: .private)")
            }
        }
    }

    static func log(response: URLResponse?, data: Data?) {
        guard mode != .minimal else { return }

        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("🔴 [NetworkLogger] Invalid Response")
            return
        }
        
        let colorIndicator = httpResponse.statusCode >= 400 ? "🔴" : "🟢"
        let url = get(url: httpResponse.url)

        logger.info("\(colorIndicator) [NetworkLogger] Response: \(url, privacy: .public)")
        logger.info("Status Code: \(httpResponse.statusCode, privacy: .public)")

        if mode == .verbose, let data, let jsonString = String(data: data, encoding: .utf8) {
            logger.debug("Response Data: \(jsonString, privacy: .private)")
        }
    }

    static func log(error: NetworkError) {
        logger.error("🔴 [NetworkLogger] ERROR: \(error.message, privacy: .public)")
    }
    
    private static func get(url: URL?) -> String {
        #if DEBUG
        return url?.absoluteString ?? "-"
        #else
        return sanitize(url: url)
        #endif
    }
}

// MARK: Sanitized URL
extension NetworkLogger {
    
    private static let sensitiveQueryParameters: Set<String> = []
    
    /// Removes sensitive query parameters from a URL
    private static func sanitize(url: URL?) -> String {
        guard let url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return "-"
        }
        
        components.queryItems = queryItems.map {
            sensitiveQueryParameters.contains($0.name) ? URLQueryItem(name: $0.name, value: "hidden") : $0
        }

        return components.string ?? "-"
    }
}
