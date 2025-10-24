//
//  ScoreGrade.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import Foundation
import SwiftUI

enum ScoreGrade: String, CaseIterable, Codable {
    case a, b, c, d, e
    case unknown
    
    init(from apiString: String?) {
        self = Self(rawValue: apiString?.lowercased() ?? "") ?? .unknown
    }
    
    var color: Color {
        switch self {
        case .a: return .green
        case .b: return .mint
        case .c: return .yellow
        case .d: return .orange
        case .e: return .red
        case .unknown: return .gray
        }
    }
    
    var displayValue: String {
        switch self {
        case .unknown: return "N/A"
        default: return rawValue.uppercased()
        }
    }
}
