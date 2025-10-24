//
//  ProductFactsResponse.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 23.10.2025.
//

import Foundation

struct ProductFactsResponse: Decodable {
    let code: String
    let product: ProductData?
}

struct ProductData: Decodable {
    let productName: String?
    let brands: String?
    let imageFrontURL: String?
    let nutriscoreGrade: String?
    let ecoscoreGrade: String?
    let ingredientsText: String?
    let nutriments: NutrimentsData
    let allergensTags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case brands
        case imageFrontURL = "image_front_url"
        case nutriscoreGrade = "nutriscore_grade"
        case ecoscoreGrade = "ecoscore_grade"
        case ingredientsText = "ingredients_text"
        case nutriments
        case allergensTags = "allergens_tags"
    }
}

struct NutrimentsData: Decodable {
    let energyKcal100g: Double?
    let fat100g: Double?
    let saturatedFat100g: Double?
    let carbohydrates100g: Double?
    let sugars100g: Double?
    let proteins100g: Double?
    let salt100g: Double?
    
    enum CodingKeys: String, CodingKey {
        case energyKcal100g = "energy-kcal_100g"
        case fat100g = "fat_100g"
        case saturatedFat100g = "saturated-fat_100g"
        case carbohydrates100g = "carbohydrates_100g"
        case sugars100g = "sugars_100g"
        case proteins100g = "proteins_100g"
        case salt100g = "salt_100g"
    }
}

// MARK: - Mock
extension ProductFactsResponse {
    static let mockResponse = ProductFactsResponse(
        code: "3017624010701",
        product: ProductData(
            productName: "Nutella",
            brands: "Ferrero",
            imageFrontURL: "https://images.openfoodfacts.org/images/products/301/762/401/0701/front_en.152.400.jpg",
            nutriscoreGrade: "e",
            ecoscoreGrade: "d",
            ingredientsText: "Sugar, palm oil, hazelnuts (13%), skimmed milk powder (8.7%), fat-reduced cocoa (7.4%), emulsifier (lecithins), vanillin.",
            nutriments: NutrimentsData(
                energyKcal100g: 539,
                fat100g: 30.9,
                saturatedFat100g: 10.6,
                carbohydrates100g: 57.5,
                sugars100g: 56.3,
                proteins100g: 6.3,
                salt100g: 0.107
            ),
            allergensTags: ["en:nuts", "en:milk", "en:soy"]
        )
    )
}
