//
//  ScannedItemCard.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

struct ScannedItemCard: View {
    let item: ScannedItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.iconName)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(item.primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.displayName ?? item.rawCode)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(item.title)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            Text(item.scanDateText)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}

#Preview("QR Code Card") {
    ScannedItemCard(
        item: .qr(QRCodeContent(rawValue: "https://github.com/apple/swift", date: Date())))
        .padding()
}

#Preview("Product Card") {
    ScannedItemCard(item: .product(.mock))
        .padding()
}
