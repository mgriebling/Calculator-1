//
//  OneLineDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/21/22.
//

import SwiftUI

struct OneLineDisplay: View {
    let text: String
    let largeFont: Font
    let smallFont: Font
    let maximalTextLength: Int
    let fontScaleFactor: CGFloat
    
    var body: some View {
        let _ = print("OneLineDisplay body \(text) \(maximalTextLength)")
        VStack(spacing: 0.0) {
            Spacer()
            HStack(spacing: 0.0) {
                Spacer()
                Text(text)
                    .foregroundColor(Color.white)
                    .scaledToFit()
                    .font(largeFont)
                    .minimumScaleFactor(1.0 / fontScaleFactor)
            }
        }
    }
}
