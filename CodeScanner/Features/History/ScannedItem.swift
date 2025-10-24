//
//  ScannedItemCard.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

enum ScannedItem: Identifiable {
    case qr(QRCodeContent)
    case product(ProductDetailViewModel)
    
    var id: String {
        switch self {
        case .qr(let content): return content.id
        case .product(let vm): return vm.id
        }
    }
    
    var displayName: String? {
        switch self {
        case .qr(let content): return content.displayName
        case .product(let vm): return vm.displayName
        }
    }
    
    var scanDate: Date {
        switch self {
        case .qr(let content): return content.scanDate
        case .product(let vm): return vm.scanDate
        }
    }
    
    var scanDateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: scanDate)
    }
    
    var rawCode: String {
        switch self {
        case .qr(let content): return content.rawValue
        case .product(let vm): return vm.code
        }
    }
    
    var title: String {
        switch self {
        case .qr(let content):
            return content.isURL ? "Link" : "Text"
        case .product(let vm):
            return vm.productName
        }
    }
    
    var subtitle: String? {
        switch self {
        case .qr(let content):
            return content.displayText.truncate(to: 40)
        case .product(let vm):
            return vm.brand
        }
    }
    
    var iconName: String {
        switch self {
        case .qr: return "qrcode"
        case .product: return "barcode"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .qr: return .blue
        case .product: return .green
        }
    }
}

extension String {
    func truncate(to length: Int) -> String {
        if count <= length { return self }
        return String(prefix(length)) + "…"
    }
}
