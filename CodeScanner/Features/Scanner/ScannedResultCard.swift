//
//  ScannedResultCard.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

struct ScannedResultCard: View {
    let item: ScannedItem
        
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(headerTitle)
                    .font(.caption.monospaced())
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: item.iconName)
                    .font(.caption)
                    .foregroundColor(item.primaryColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private var headerTitle: String {
        switch item {
        case .qr:
            return "QR Code"
        case .product(let vm):
            return vm.code
        }
    }
}

#Preview {
    let item = ScannedItem.product(.mock)
    ScannedResultCard(item: item)
}
