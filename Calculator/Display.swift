//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/25/22.
//

import SwiftUI

struct Display {
    let data: DisplayData
    let format: DisplayFormat
}

struct DisplayData {
    var left: String
    var right: String?
    var maxlength: Int
    var canBeInteger: Bool
    var canBeFloat: Bool
    var isZero: Bool {
        left == "0" && right == nil
    }
    
    var oneLine: String {
        left + (right ?? "")
    }
    var length: Int {
        var ret = left.count
        if right != nil { ret += right!.count }
        return ret
    }
}

extension DisplayData {
    init(left: String) {
        self.left = left
        right = nil
        maxlength = 0
        canBeInteger = false
        canBeFloat = false
    }
    init(number: Number, forceScientific: Bool = false, screen: Screen) {
        self.left = "0"
        right = nil
        maxlength = 0
        canBeInteger = false
        canBeFloat = false
        self = fromNumber(number, screen: screen)
    }
    init(stringNumber: String, screen: Screen) {
        self.left = "0"
        right = nil
        maxlength = 0
        canBeInteger = false
        canBeFloat = false
        self = fromStringNumber(stringNumber, screen: screen)
    }
}

extension DisplayData {
    func fromLeft(_ left: String) -> DisplayData {
        return DisplayData(left: left)
    }

    func fromNumber(_ number: Number, screen: Screen) -> DisplayData {
        if number.str != nil {
            return fromStringNumber(number.str!, screen: screen)
        }

        guard number.gmp != nil else {
            assert(false, "DisplayData candidate no str and no gmp")
            return fromLeft("error")
        }

        let displayGmp: Gmp = number.gmp!

        if displayGmp.NaN {
            return fromLeft("not a number")
        }
        if displayGmp.inf {
            return fromLeft("infinity")
        }

        if displayGmp.isZero {
            return fromLeft("0")
        }

        let (mantissa, exponent) = displayGmp.mantissaExponent(len: min(displayGmp.precision, Number.MAX_DISPLAY_LENGTH))
        
        return fromMantissaAndExponent(mantissa, exponent, screen: screen)
    }

    func fromStringNumber(_ stringNumber: String, screen: Screen) -> DisplayData {
        guard !stringNumber.contains(",") else { assert(false, "string contains comma, but only dot is allowed") }
        guard !stringNumber.contains("e") else { assert(false, "scientific?") }
        
        var mantissa: String
        var exponent: Int
        
        /// stringNumber fits in the display? show it!
        let correctSeparator: String
        mantissa = stringNumber
        if stringNumber.starts(with: "-") {
            let temp = String(mantissa.dropFirst())
            correctSeparator = withSeparators(numberString: temp, isNegative: true, screen: screen)
        } else {
            correctSeparator = withSeparators(numberString: mantissa, isNegative: false, screen: screen)
        }
        if textWidth(correctSeparator, screen: screen) <= screen.displayWidth {
            return fromLeft(correctSeparator)
        }
        
        /// integer or float
        if stringNumber.contains(".") {
            /// float
            let tempArray = stringNumber.split(separator: ".")
            
            var integerPart: String = ""
            var fractionPart: String = ""
            if tempArray.count == 1 {
                integerPart = String(tempArray[0])
                fractionPart = ""
            } else if tempArray.count == 2 {
                integerPart = String(tempArray[0])
                fractionPart = String(tempArray[1])
            } else {
                assert(false, "DisplayData: tempArray.count = \(tempArray.count)")
            }
            
            mantissa = integerPart + fractionPart
            exponent = integerPart.count - 1
            while mantissa.starts(with: "0") {
                mantissa = mantissa.replacingFirstOccurrence(of: "0", with: "")
                exponent -= 1
            }
        } else {
            /// no dot --> integer
            mantissa = stringNumber
            exponent = stringNumber.count - 1
        }
        if mantissa.starts(with: "-") { exponent -= 1 }
        return fromMantissaAndExponent(mantissa, exponent, screen: screen)
    }
    
    func withSeparators(numberString: String, isNegative: Bool, screen: Screen) -> String {
        var integerPart: String
        let fractionalPart: String
        
        if numberString.contains(".") {
            integerPart = numberString.before(first: ".")
            fractionalPart = numberString.after(first: ".")
        } else {
            /// integer
            integerPart = numberString
            fractionalPart = ""
        }
        
        if let c = screen.groupingSeparator.character {
            var count = integerPart.count
            while count >= 4 {
                count = count - 3
                integerPart.insert(c, at: integerPart.index(integerPart.startIndex, offsetBy: count))
            }
        }
        let minusSign = isNegative ? "-" : ""
        if numberString.contains(".") {
            return minusSign + integerPart + screen.decimalSeparator.string + fractionalPart
        } else {
            return minusSign + integerPart
        }
    }
    
    private func textSize(string: String, screen: Screen, kerning: CGFloat) -> CGSize {
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = kerning
        attributes[.font] = screen.uiFont
        return string.size(withAttributes: attributes)
    }
    func textWidth(_ string: String, screen: Screen, uiFont: UIFont? = nil, kerning: CGFloat = 0.0) -> CGFloat {
        textSize(string: string, screen: screen, kerning: kerning).width
    }
    
    func textHeight(_ string: String, screen: Screen, uiFont: UIFont? = nil, kerning: CGFloat = 0.0) -> CGFloat {
        textSize(string: string, screen: screen, kerning: kerning).height
    }
    
    private func fromMantissaAndExponent(_ mantissa_: String, _ exponent: Int, screen: Screen) -> DisplayData {
        var mantissa = mantissa_
        
        if mantissa.isEmpty {
            mantissa = "0"
        }
        
        /// negative? Special treatment
        let isNegative = mantissa.first == "-"
        if isNegative {
            mantissa.removeFirst()
        }
        
        /// Can be displayed as Integer?
        /*
         123,456,789,012,345,678,901,123,456 --> 400 pixel
         What can be displayed in 200 pixel?
         - I dont want the separator as leading character!
         */
        if mantissa.count <= exponent + 1 { /// smaller than because of possible trailing zeroes in the integer
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
            let withSeparators = withSeparators(numberString: mantissa, isNegative: isNegative, screen: screen)
            if textWidth(withSeparators, screen: screen) <= screen.displayWidth {
                return DisplayData(left: withSeparators, right: nil, maxlength: 0, canBeInteger: true, canBeFloat: false)
            }
        }
        
        /// Is floating point XXX,xxx?
        if exponent >= 0 {
            var floatString = mantissa
            let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
            var indexInt: Int = floatString.distance(from: floatString.startIndex, to: index)
            floatString.insert(".", at: index)
            floatString = withSeparators(numberString: floatString, isNegative: isNegative, screen: screen)
            if let index = floatString.firstIndex(of: screen.decimalSeparator.character) {
                indexInt = floatString.distance(from: floatString.startIndex, to: index)
                let floatCandidate = String(floatString.prefix(indexInt+1))
                if textWidth(floatCandidate, screen: screen) <= screen.displayWidth {
                    return DisplayData(left: floatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
                }
            }
            /// is the comma visible in the first line and is there at least one digit after the comma?
        }
        
        /// is floating point 0,xxxx
        /// additional requirement: first non-zero digit in first line. If not -> Scientific
        if exponent < 0 {
            let minusSign = isNegative ? "-" : ""
            
            var testFloat = minusSign + "0" + screen.decimalSeparator.string
            var floatString = mantissa
            for _ in 0..<(-1*exponent - 1) {
                floatString = "0" + floatString
                testFloat += "0"
            }
            testFloat += "x"
            if textWidth(testFloat, screen: screen) <= screen.displayWidth {
                floatString = minusSign + "0" + screen.decimalSeparator.string + floatString
                return DisplayData(left: floatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
            }
        }
        
        mantissa = mantissa_
        if isNegative {
            mantissa.removeFirst()
        }
        
        let secondIndex = mantissa.index(mantissa.startIndex, offsetBy: 1)
        mantissa.insert(".", at: secondIndex)
        if mantissa.count == 2 {
            // 4.
            mantissa.append("0")
        }
        mantissa = withSeparators(numberString: mantissa, isNegative: isNegative, screen: screen)
        let exponentString = "e\(exponent)"
        return DisplayData(left: mantissa, right: exponentString, maxlength: 0, canBeInteger: false, canBeFloat: true)
    }
}

struct DisplayFormat {
    let font: Font
    let color: Color
    let showThreeDots: Bool
    let digitWidth: CGFloat
    let ePadding: CGFloat
    let kerning: CGFloat
    
    init(for length: Int, withMaxLength maxLength: Int, showThreeDots: Bool, screen: Screen) {
        var factor = 1.0
        
        if screen.isPortraitPhone {
            let factorMin = 1.0
            let factorMax = 2.0
            // if factorMax is too large (above 2.3) the space needed
            // for the new caracter is more then the shrinking,
            // which results in the string to be too long
            
            let notOccupiedLength = CGFloat(length) / CGFloat(maxLength)
            factor = factorMax - notOccupiedLength * (factorMax - factorMin)
            if factor > 1.5 { factor = 1.5 }
            if factor < 1.0 { factor = 1.0 }
        }
        let uiFont = UIFont.monospacedDigitSystemFont(ofSize: screen.uiFontSize * factor, weight: screen.uiFontWeight)
        
        font = Font(uiFont)
        color = showThreeDots ? .gray : .white
        self.showThreeDots = showThreeDots
        self.digitWidth = screen.digitWidth
        self.ePadding = screen.ePadding
        self.kerning = screen.kerning
    }
}
