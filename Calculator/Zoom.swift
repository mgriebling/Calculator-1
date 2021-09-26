//
//  Zoom.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

struct Zoom: View {
    var hasMoreDigits: Bool
    @Binding var zoomed: Bool
    var body: some View {
        let symbolSize = Configuration.shared.displayFontSize*0.5
        let yPadding = Configuration.shared.displayFontSize/1.7 - symbolSize/2
        HStack {
            Spacer()
            VStack {
                ZStack {
                    Group {
                        if zoomed {
                            Image(systemName: "minus.circle.fill")
                        } else {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    .font(Font.system(size: symbolSize, weight: .bold).monospacedDigit())
                    .foregroundColor(
                        hasMoreDigits ?
                        Configuration.shared.OpKeyProperties.color :
                            Color(white: 0.5))
                    .contentShape(Rectangle())
                    .padding(-0.1*symbolSize)
                    .background(hasMoreDigits ? Color.white : Color.clear)
                    .clipShape(Circle())
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            zoomed.toggle()
                        }
                    }
                }
                .fixedSize(horizontal: true, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(.trailing, symbolSize/2)
            .padding(.top, yPadding)
        }
    }
}


struct Zoom_Previews: PreviewProvider {
    static var previews: some View {
        Zoom(hasMoreDigits: true, zoomed: .constant(false))
    }
}
