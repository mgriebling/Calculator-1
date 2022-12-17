//
//  LengthMeasurement.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/1/22.
//

import SwiftUI

struct Lengths {
    let withoutComma: Int
    let withCommaNonScientific: Int
    let withCommaScientific: Int
    let height: CGFloat
    let infoHeight: CGFloat
    let ePadding: CGFloat
    
    init(withoutComma: Int, withCommaNonScientific: Int, withCommaScientific: Int, height: CGFloat, infoHeight: CGFloat, ePadding: CGFloat) {
        self.withoutComma = withoutComma
        self.withCommaNonScientific = withCommaNonScientific
        self.withCommaScientific = withCommaScientific
        self.height = height
        self.infoHeight = infoHeight
        self.ePadding = ePadding
    }
    init(_ len: Int) {
        self.init(withoutComma: len, withCommaNonScientific: len, withCommaScientific: len, height: 0, infoHeight: 0, ePadding: 0)
    }
}

// To debug length errors add this in Calculator:
//let fontAttribute = [NSAttributedString.Key.font: screenInfo.uiFont]
//let xxx = model.displayData.longLeft.size(withAttributes: fontAttribute)  // for Single Line
//let xxx = "0".size(withAttributes: fontAttribute)  // for Single Line
//let _ = print("Calculator len \(model.displayData.longLeft) \(xxx.width)")


func lengthMeasurement(width: CGFloat, uiFont: UIFont, infoUiFont: UIFont, ePadding: CGFloat) -> Lengths {
//     print("lengthMeasurement w =\(width)")
    var s = ""
    var w = s.textSize(for: uiFont).width
    while w < width {
        s.append("0")
        w = s.textSize(for: uiFont).width
//        print("measure \(s) \(s.count) \(w)")
    }
    let withoutComma = s.count - 1
    
    s = ","
    w = s.textSize(for: uiFont).width
    while w < width {
        s.append("0")
        w = s.textSize(for: uiFont).width
//        print("measure , \(s) \(s.count) \(w)")
    }
    let height = s.textSize(for: uiFont).height
    let withCommaNonScientific = s.count - 1
    
    //print("ePadding set to \(ePadding)")
    s = ",e"
    w = s.textSize(for: uiFont).width
    while w < (width - ePadding) {
        s.append("0")
        w = s.textSize(for: uiFont).width
//        print("measure e \(s) \(s.count) \(w)")
    }
    let withCommaScientific = s.count - 1

    let result = Lengths(
        withoutComma: withoutComma,
        withCommaNonScientific: withCommaNonScientific,
        withCommaScientific: withCommaScientific,
        height: height,
        infoHeight: "info".textSize(for: infoUiFont).height,
        ePadding: ePadding)
    // print("lengthMeasurement \(result)")
    return result
}

    
fileprivate extension String {
    func textSize(for uiFont: UIFont) -> CGSize {
        //  attrString.addAttribute(NSAttributedStringKey.kern, value: 2, range: NSMakeRange(0, attrString.length))

        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = C.kerning
//        attributes[.strokeWidth] = 300
        attributes[.font] = uiFont
//        let fontAttribute = [NSAttributedString.Key.font: uiFont]
        let size = self.size(withAttributes: attributes)  // for Single Line
        return size;
    }
}
