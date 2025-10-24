//
//  ProductDetailView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

struct ProductDetailView: View {
    @StateObject var viewModel: ProductDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                
                scoresSection
                
                ingredientsSection
                
                if !viewModel.allergens.isEmpty {
                    allergensSection
                }
                
                NutritionFactsView(viewModel: viewModel)
            }
            .padding()
        }
        .navigationTitle(viewModel.productName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ProductDetailView {
    
    // MARK: Header
    var headerSection: some View {
        VStack(spacing: 12) {
            AsyncImage(url: viewModel.imageURL) { phase in
                switch phase {
                case .empty:
                    Color.gray.opacity(0.2)
                        .frame(height: 220)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure:
                    Color.gray.opacity(0.2)
                        .frame(height: 220)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxHeight: 220)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 4)
            
            if let displayName = viewModel.displayName {
                Text(displayName)
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
            }
            
            Text(viewModel.productName)
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center)
            Text(viewModel.code)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
            Text(viewModel.brand)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: Scores
    var scoresSection: some View {
        HStack(spacing: 32) {
            ScoreBadgeView(title: "Nutri‑Score", grade: viewModel.nutriscoreGrade)
            ScoreBadgeView(title: "Eco‑Score", grade: viewModel.ecoscoreGrade)
        }
    }
    
    // MARK: Ingredients
    var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
            
            Text(viewModel.ingredientsText)
                .font(.body)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // MARK: Allergens
    var allergensSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Allergens")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                ForEach(viewModel.allergens, id: \.self) { allergen in
                    Text(allergen)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.orange.opacity(0.2)))
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    ProductDetailView(viewModel: .mock)
}
