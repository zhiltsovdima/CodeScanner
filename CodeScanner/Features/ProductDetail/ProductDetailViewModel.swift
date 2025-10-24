//
//  ProductDetailViewModel.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import Combine
import SwiftUI

final class ProductDetailViewModel: ObservableObject, Codable {
    let id: String
    let code: String
    let scanDate: Date
    var displayName: String?
    
    let productName: String
    let brand: String
    let imageURL: URL?
    
    let nutriscoreGrade: ScoreGrade
    let ecoscoreGrade: ScoreGrade
    
    let ingredientsText: String
    let allergens: [String]
    
    let energyKcal: String
    let fat: String
    let saturatedFat: String
    let carbohydrates: String
    let sugars: String
    let proteins: String
    let salt: String
    
    init(from response: ProductFactsResponse) {
        self.id = UUID().uuidString
        self.code = response.code
        self.scanDate = Date()
        
        let data = response.product ?? ProductData(
            productName: nil, brands: nil, imageFrontURL: nil,
            nutriscoreGrade: nil, ecoscoreGrade: nil,
            ingredientsText: nil, nutriments: NutrimentsData(
                energyKcal100g: nil, fat100g: nil, saturatedFat100g: nil,
                carbohydrates100g: nil, sugars100g: nil,
                proteins100g: nil, salt100g: nil),
            allergensTags: nil)
        
        self.productName = data.productName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "—"
        self.brand       = data.brands?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "—"
        self.imageURL    = data.imageFrontURL.flatMap { URL(string: $0) }
        
        self.nutriscoreGrade = ScoreGrade(from: data.nutriscoreGrade)
        self.ecoscoreGrade   = ScoreGrade(from: data.ecoscoreGrade)
        
        self.ingredientsText = data.ingredientsText?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "—"
        self.allergens       = data.allergensTags ?? []
        
        let fmt = { (value: Double?) in
            value.map { String(format: "%.1f g", $0) } ?? "—"
        }
        let kcalFmt = { (value: Double?) in
            value.map { String(format: "%.0f kcal", $0) } ?? "—"
        }
        
        let n = data.nutriments
        self.energyKcal      = kcalFmt(n.energyKcal100g)
        self.fat             = fmt(n.fat100g)
        self.saturatedFat    = fmt(n.saturatedFat100g)
        self.carbohydrates   = fmt(n.carbohydrates100g)
        self.sugars          = fmt(n.sugars100g)
        self.proteins        = fmt(n.proteins100g)
        self.salt            = fmt(n.salt100g)
    }
}

// MARK: - Mock
extension ProductDetailViewModel {
    static let mock = ProductDetailViewModel(from: .mockResponse)
}
