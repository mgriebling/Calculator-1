//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

let testColors = false

struct MyNavigation<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(root: content)
        } else {
            NavigationView(content: content)
        }
    }
}

struct Calculator: View {
    @ObservedObject var model: Model
    @StateObject var store = Store()

    var body: some View {
        // let _ = print("Calculator: isPortraitPhone \(model.screenInfo.isPortraitPhone) size \(model.screenInfo.calculatorSize)")
        // let _ = print("model.displayData.left \(model.displayData.left)")
        if model.screenInfo.isPortraitPhone {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                PortraitDisplay(
                    display: model.display,
                    screenInfo: model.screenInfo,
                    digitWidth: model.lengths.digitWidth)
                //.background(Color.yellow)
                .padding(.horizontal, model.screenInfo.portraitIPhoneDisplayHorizontalPadding)
                .padding(.bottom, model.screenInfo.portraitIPhoneDisplayBottomPadding)
                NonScientificKeyboard(
                    model: model,
                    spacing: model.screenInfo.keySpacing,
                    keySize: model.screenInfo.keySize)
            }
            //.background(Color.blue)
            .padding(.horizontal, model.screenInfo.portraitIPhoneHorizontalPadding)
            .padding(.bottom, model.screenInfo.portraitIPhoneBottomPadding)
        } else {
            MyNavigation {
                /*
                 lowest level: longDisplay and Icons
                 mid level: Keyboard with info and rectangle on top
                 top level: single line
                 */
                let color: Color = (model.isCopying || model.isPasting) ? .orange : model.display.format.color
                HStack(alignment: .top, spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    ScrollViewConditionalAnimation(
                        text: model.display.data.left,
                        font: Font(model.screenInfo.uiFont),
                        foregroundColor: color,
                        backgroundColor: testColors ? .yellow : .black,
                        offsetY: model.offsetToVerticallyAlignTextWithkeyboard,
                        disabled: !model.isZoomed,
                        scrollViewHasScolled: $model.scrollViewHasScrolled,
                        scrollViewID: model.scrollViewID,
                        preliminary: model.display.data.showThreeDots,
                        digitWidth: model.lengths.digitWidth)
                    if model.display.data.right != nil {
                        Text(model.display.data.right!)
                            .kerning(C.kerning)
                            .font(Font(model.screenInfo.uiFont))
                            .foregroundColor(color)
                            .padding(.leading, model.screenInfo.ePadding)
                        .offset(y: model.offsetToVerticallyAlignTextWithkeyboard)
                    }
                    Icons(
                        store: store,
                        model: model,
                        screenInfo: model.screenInfo,
                        isZoomed: $model.isZoomed)
                    .offset(y: model.offsetToVerticallyIconWithText)
                }
                .overlay() {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(height: model.lengths.infoHeight)
                            .overlay() {
                                let info = "\(model.hasBeenReset ? "Precision: "+model.precisionDescription+" digits" : "\(model.rad ? "Rad" : "")")"
                                if info.count > 0 {
                                    HStack(spacing: 0.0) {
                                        Text(info)
                                            .foregroundColor(.white)
                                            .font(Font(model.screenInfo.infoUiFont))
                                        Spacer()
                                    }
                                    .padding(.leading, model.screenInfo.keySize.width * 0.3)
                                    //                                .offset(x: screenInfo.keySpacing, y: -screenInfo.keyboardHeight)
                                }
                            }
                        HStack(spacing: 0.0) {
                            ScientificBoard(model: model, spacing: model.screenInfo.keySpacing, keySize: model.screenInfo.keySize)
                                .padding(.trailing, model.screenInfo.keySpacing)
                            NonScientificKeyboard(model: model, spacing: model.screenInfo.keySpacing, keySize: model.screenInfo.keySize)
                        }
                        .background(Color.black)
                    }
                    .offset(y: model.isZoomed ? model.screenInfo.calculatorSize.height : 0.0)
                    .transition(.move(edge: .bottom))
                }
            }
            .accentColor(.white) // for the navigation back button
            .onChange(of: model.lengths.withoutComma) { _ in
                model.updateDisplayData() // redraw with or without keyboard
            }
        }
    }
}


extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
