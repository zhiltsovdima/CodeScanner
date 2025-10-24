//
//  NutritionFactsView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

struct NutritionFactsView: View {
    private let rows: [NutritionRow]
    
    init(viewModel: ProductDetailViewModel) {
        self.rows = [
            NutritionRow(
                label: "Energy",
                value: viewModel.energyKcal,
                shouldShowDivider: true
            ),
            NutritionRow(
                label: "Fat",
                value: viewModel.fat
            ),
            NutritionRow(
                label: "  of which saturates",
                value: viewModel.saturatedFat,
                isSubrow: true,
                shouldShowDivider: true
            ),
            NutritionRow(
                label: "Carbohydrate",
                value: viewModel.carbohydrates
            ),
            NutritionRow(
                label: "  of which sugars",
                value: viewModel.sugars,
                isSubrow: true,
                shouldShowDivider: true
            ),
            NutritionRow(
                label: "Protein",
                value: viewModel.proteins,
                shouldShowDivider: true
            ),
            NutritionRow(
                label: "Salt",
                value: viewModel.salt
            )
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nutrition facts (per 100 g)")
                .font(.headline)
            
            Grid(
                alignment: .leading,
                horizontalSpacing: 16,
                verticalSpacing: 8
            ) {
                ForEach(rows.indices, id: \.self) { index in
                    let row = rows[index]
                    
                    GridRow {
                        Text(row.label)
                            .padding(.leading, row.isSubrow ? 16 : 0)
                            .gridColumnAlignment(.leading)
                        
                        Text(row.value)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .gridColumnAlignment(.trailing)
                    }
                    
                    if row.shouldShowDivider {
                        Divider().gridCellColumns(2)
                    }
                }
            }
            .font(.subheadline)
            .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: – NutritionRow
private extension NutritionFactsView {
    struct NutritionRow {
        let label: String
        let value: String
        let isSubrow: Bool
        let shouldShowDivider: Bool
        
        init(label: String, value: String, isSubrow: Bool = false, shouldShowDivider: Bool = false) {
            self.label = label
            self.value = value
            self.isSubrow = isSubrow
            self.shouldShowDivider = shouldShowDivider
        }
    }
}

#Preview {
    NutritionFactsView(viewModel: .mock)
}
