//
//  QrCodeContent.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import Foundation

struct QRCodeContent {
    let id: String
    let rawValue: String
    let type: ContentType
    let scanDate: Date
    var displayName: String?
    
    enum ContentType {
        case url(URL)
        case text
    }
    
    init(rawValue: String, date: Date) {
        self.id = UUID().uuidString
        self.rawValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let url = URL(string: self.rawValue), url.scheme != nil {
            self.type = .url(url)
        } else {
            self.type = .text
        }
        self.scanDate = date
    }
    
    var displayText: String {
        switch type {
        case .url(let url):
            return url.absoluteString
        case .text:
            return rawValue
        }
    }
    
    var isURL: Bool {
        if case .url = type { return true }
        return false
    }
    
    var url: URL? {
        if case .url(let url) = type { return url }
        return nil
    }
}
