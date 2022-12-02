//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct Calculator: View {
    @StateObject private var keyModel = KeyModel()
    let isPad: Bool
    var isPortrait: Bool
    let size: CGSize
    
    var keyboardSize: CGSize
    var displaySize: CGSize
    var singleLineFontSize: CGFloat
    let displayLength: [Int]
    
    var body: some View {
        let _ = print("Calculator body")
        let info1 = "\(keyModel._hasBeenReset ? "Precision: "+keyModel.precisionDescription+" digits" : "")"
        let info2 = "\(keyModel._rad ? "Rad      " : "")"
        let text = keyModel.oneLineP
        if isPad {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                KeysView(keyModel: keyModel, isScientific: false, size: keyboardSize)
            }
        } else {
            ZStack {
                /// display and keyboard
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        if keyModel.zoomed {
                            LongDisplay(keyModel: keyModel, fontSize: singleLineFontSize)
                                .padding(.top, displaySize.height * 0.21)
                                .padding(.trailing, displaySize.height * 0.9)
                                .transition(.opacity)
                        } else {
                            OneLineDisplay(
                                text: text,
                                size: displaySize,
                                largeFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize * (isPortrait ? 1.5 : 1.0), weight: .thin)),
                                smallFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                                maximalTextLength: text.contains(",") ? keyModel.oneLineWithCommaLength : keyModel.oneLineWithoutCommaLength)
                            .padding(.trailing, isPortrait ? 0.0 : displaySize.height * 0.9)
                            .transition(.opacity)
                        }
                    }
                    if !keyModel.zoomed {
                        KeysView(keyModel: keyModel, isScientific: !isPortrait, size: keyboardSize)
                            .padding(.bottom, isPortrait ? size.height*0.06 : 0.0)
                    }
                }
                
                /// Icons
                if !isPortrait {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            PlusKey(keyInfo: keyModel.keyInfo["plusKey"]!, keyModel: keyModel, size: CGSize(width: keyboardSize.height * 0.13, height: keyboardSize.height * 0.13))
                                .padding(.bottom, keyboardSize.height + displaySize.height * 0.12)
                        }
                    }
                }
                
                /// info1, info2 and animated dots
                if !keyModel.zoomed {
                    VStack(spacing: 0.0) {
                        if keyModel.isCalculating {
                            Spacer(minLength: 0.0)
                            HStack(spacing: 0.0) {
                                AnimatedDots(color: Color(white: 0.7))
                                    .padding(.top, displaySize.height * 0.2)
                                Spacer()
                            }
                            Spacer(minLength: 0.0)
                        } else {
                            HStack(spacing: 0.0) {
                                Text(info1)
                                    .foregroundColor(Color.white)
                                Spacer()
                            }
                            Spacer()
                            HStack(spacing: 0.0) {
                                Text(info2)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom, displaySize.height * 0.2)
                                Spacer()
                            }
                        }
                    }
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, keyboardSize.height)//+displaySize.height*0.2)
                    .padding(.leading, displaySize.height*0.4)
                }
            }
            .onAppear() {
                keyModel.oneLineWithCommaLength = displayLength[0]
                keyModel.oneLineWithoutCommaLength = displayLength[1]
                print("displayLength \(displayLength)")
            }
        }
        
        if keyModel.zoomed && !isPortrait {
            //            LongDisplay(text: viewLogic.longText, uiFont: viewLogic.displayUIFont, isCopyingOrPasting: viewLogic.isCopyingOrPasting, color: viewLogic.textColor)
            
            //            MultiLineDisplay(brain: Brain(), t: TE(), isCopyingOrPasting: false)
            //                .padding(.trailing, TE().trailingAfterDisplay)
            //        } else {
            //            Spacer(minLength: 0.0)
            //            SingleLineDisplay(brain: Brain(), t: TE())
            //                .padding(.trailing, TE().trailingAfterDisplay)
        }
    }
}


//struct Calculator_Previews: PreviewProvider {
//    static var previews: some View {
//        Calculator(isPad: false, isPortrait: true, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            .background(Color.black)
//    }
//}
