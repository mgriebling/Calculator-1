//
//  Key.swift
//  Calculator
//
//  Created by Joachim Neumann on 21/09/2021.
//

import SwiftUI


struct Key: View {
    private var asText: Text? = nil
    private var asImage: Image? = nil
    private var asView: AnyView? = nil
    
    private let sfImageNames: [String: String] = [
        "+":   "plus",
        "-":   "minus",
        "x":   "multiply",
        "/":   "divide",
        "+/-": "plus.slash.minus",
        "=":   "equal",
        "%":   "percent",
    ]

    private let shapeNames: [String: AnyView] = [
        "√":        AnyView(Root("2")),
        "3√":       AnyView(Root("3")),
        "y√":       AnyView(Root("y")),
        "log10":    AnyView(Log10()),
        "log2":     AnyView(Logx("2")),
        "logy":     AnyView(Logx("y")),
        "One_x":    AnyView(One_x()),
        "x^2":      AnyView(Pow(base:  "x",   exponent: "2",  baseXOffset: 0.0,   exponentXOffset: 0.0)),
        "x^3":      AnyView(Pow(base:  "x",   exponent: "3",  baseXOffset: 0.0,   exponentXOffset: 0.0)),
        "x^y":      AnyView(Pow(base:  "x",   exponent: "y",  baseXOffset: 0.0,   exponentXOffset: 0.0)),
        "e^x":      AnyView(Pow(base:  "e",   exponent: "x",  baseXOffset: 0.0,   exponentXOffset: 0.0)),
        "y^x":      AnyView(Pow(base:  "y",   exponent: "x",  baseXOffset: 0.0,   exponentXOffset: 0.0)),
        "2^x":      AnyView(Pow(base:  "2",   exponent: "x",  baseXOffset: 0.0,   exponentXOffset: 0.0)),
        "10^x":     AnyView(Pow(base: "10",   exponent: "x",  baseXOffset: 0.0,   exponentXOffset: 0.1)),
        "2nd":      AnyView(Pow(base: "2",    exponent: "nd", baseXOffset: -0.05, exponentXOffset: 0.0)),
        "asin":     AnyView(Pow(base: "sin",  exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.14)),
        "acos":     AnyView(Pow(base: "cos",  exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.2)),
        "atan":     AnyView(Pow(base: "tan",  exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.18)),
        "asinh":    AnyView(Pow(base: "sinh", exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.25)),
        "acosh":    AnyView(Pow(base: "cosh", exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.30)),
        "atanh":    AnyView(Pow(base: "tanh", exponent: "-1", baseXOffset: 0.0,   exponentXOffset: 0.29)),
    ]

    var body: some View {
        if let asImage = asImage {
            asImage
        } else if let asView = asView {
            asView
        } else if let asText = asText {
            asText
        }
    }
    
    init(_ text: String) {
        if let sfImage = sfImageNames[text] {
            asImage = Image(systemName: sfImage)
        } else if let shape = shapeNames[text] {
            asView = shape
        } else {
            asText = Text(text)
        }
    }
}

private struct Digit_0_to_9: ViewModifier {
    let size: CGSize
    let isValidKey: Bool
    let callback: (() -> Void)?
    func body(content: Content) -> some View {
        content
            .foregroundColor(callback == nil ?  Color.gray : Configuration.shared.DigitKeyProperties.textColor)
            .addBackground(with: Configuration.shared.DigitKeyProperties, isValidKey: isValidKey, callback: callback)
            .font(.system(size: size.height * CGFloat(0.48)))
    }
}

private struct Colorful_plus_minus_etc: ViewModifier {
    let size: CGSize
    let isValidKey: Bool
    let callback: (() -> Void)?
    func body(content: Content) -> some View {
        let fontsize = size.height * CGFloat(0.36)
        content
            .foregroundColor(callback == nil ?  Color.gray : Configuration.shared.OpKeyProperties.textColor)
            .addBackground(with: Configuration.shared.OpKeyProperties, isValidKey: isValidKey, callback: callback)
            .font(.system(size: fontsize, weight: .bold))
        
    }
}

private struct PlusMinus_percentage: ViewModifier {
    let size: CGSize
    let isValidKey: Bool
    let callback: (() -> Void)?
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.36
        content
            .foregroundColor(callback == nil ?  Color.gray : Configuration.shared.LightGrayKeyProperties.textColor)
            .addBackground(with: Configuration.shared.LightGrayKeyProperties, isValidKey: isValidKey, callback: callback)
            .font(.system(size: fontsize, weight: .bold))
    }
}

private struct ScientificButton: ViewModifier {
    let size: CGSize
    let isValidKey: Bool
    let callback: (() -> Void)?
    func body(content: Content) -> some View {
        let fontsize = size.height * 0.40
        content
            .foregroundColor(callback == nil ?  Color.gray : Configuration.shared.LightGrayKeyProperties.textColor)
            .addBackground(with: Configuration.shared.LightGrayKeyProperties, isValidKey: isValidKey, callback: callback)
            .font(.system(size: fontsize, weight: .regular))
    }
}


extension View {
    func digit_1_to_9(size: CGSize, isValidKey: Bool, callback: (() -> Void)? = nil) -> some View {
        self
            .modifier(Digit_0_to_9(size: size, isValidKey: isValidKey, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func digit_0(size: CGSize, space: CGFloat, isValidKey: Bool, callback: (() -> Void)? = nil ) -> some View {
        HStack {
            self
                .padding(.leading, size.height * 0.4)
            Spacer()
        }
        .modifier(Digit_0_to_9(size: size, isValidKey: isValidKey, callback: callback))
        .frame(width: size.width*2+space, height: size.height)
    }
    
    func op_div_mul_add_sub_eq(size: CGSize, isValidKey: Bool, callback: (() -> Void)? = nil ) -> some View {
        self
            .modifier(Colorful_plus_minus_etc(size: size, isValidKey: isValidKey, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func op_plusMinus_percentage(size: CGSize, isValidKey: Bool, callback: (() -> Void)? = nil ) -> some View {
        self
            .modifier(PlusMinus_percentage(size: size, isValidKey: isValidKey, callback: callback))
            .frame(width: size.width, height: size.height)
    }
    
    func scientific(size: CGSize, isValidKey: Bool, callback: (() -> Void)? = nil ) -> some View {
        self
            .modifier(ScientificButton(size: size, isValidKey: isValidKey, callback: callback))
            .frame(width: size.width, height: size.height)
    }
}
