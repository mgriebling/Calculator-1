//
//  AllDigitsView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    var brain: Brain
    let textColor: Color // for copy/paste animation
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: true) {
                Text(brain.longDisplayString)
                    .foregroundColor(textColor)
                    .font(Configuration.shared.allDigitsFont)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .padding(.top, 0.2) /// TODO: Unterstand why this magically persuads the Scrollview to respect the SafeArea
    }
}

struct AllDigitsView_Previews: PreviewProvider {
    static var previews: some View {
        AllDigitsView(brain: Brain(), textColor: Color.white)
    }
}
