//
//  ScoreBadgeView.swift
//  CodeScanner
//
//  Created by Dima Zhiltsov on 24.10.2025.
//

import SwiftUI

struct ScoreBadgeView: View {
    let title: String
    let grade: ScoreGrade
        
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Text(grade.displayValue)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(grade.color)
                )
        }
    }
}

#Preview {
    ScoreBadgeView(title: "Title", grade: .a)
}
