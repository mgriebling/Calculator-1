//
//  Constants.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

class ColorsOf {
    var textColor: UIColor
    var upColor: UIColor
    var downColor: UIColor
    init(textColor: UIColor, upColor: UIColor, downColor: UIColor) {
        self.textColor = textColor
        self.upColor = upColor
        self.downColor = downColor
    }
}

struct C {    
    static let appBackgroundUI: UIColor = UIColor.black
    static let appBackground = Color(appBackgroundUI)
    static let digitColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.2, alpha: 1.0),
        downColor: UIColor(white: 0.4, alpha: 1.0))
    static let disabledColor = UIColor.red
    static let operatorColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.5, alpha: 1.0),
        downColor: UIColor(white: 0.7, alpha: 1.0))
    static let pendingOperatorColors = ColorsOf(
        textColor: UIColor(white: 0.3, alpha: 1.0),
        upColor:   UIColor(white: 0.9, alpha: 1.0),
        downColor: UIColor(white: 0.8, alpha: 1.0))
    static let scientificColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.12, alpha: 1.0),
        downColor: UIColor(white: 0.32, alpha: 1.0))
    static let pendingScientificColors = ColorsOf(
        textColor: UIColor(white: 0.3, alpha: 1.0),
        upColor:   UIColor(white: 0.7, alpha: 1.0),
        downColor: UIColor(white: 0.6, alpha: 1.0))
    static let secondColors = ColorsOf(
        textColor: UIColor(.white),
        upColor:   UIColor(white: 0.12, alpha: 1.0),
        downColor: UIColor(white: 0.12, alpha: 1.0))
    static let secondActiveColors = ColorsOf(
        textColor: UIColor(white: 0.2, alpha: 1.0),
        upColor:   UIColor(white: 0.6, alpha: 1.0),
        downColor: UIColor(white: 0.6, alpha: 1.0))
    
    static func spaceBetween(keyWidth: CGFloat) -> CGFloat {
        0.1 * keyWidth
    }

    static func doubleKeyWidth(keyWidth : CGFloat) -> CGFloat {
        2 * keyWidth + spaceBetween(keyWidth: keyWidth)
    }
    
    static func getKeyColors(for symbol: String) -> ColorsOf {
        if keysForDigits.contains(symbol) {
            return digitColors
        } else if symbol == "2nd" {
            return secondColors
        } else if keysOfOperator.contains(symbol) {
            return operatorColors
        } else if keysOfScientificOperators.contains(symbol) {
            return scientificColors
        }
        return digitColors
    }

    static let keysForDigits: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    static let keysOfOperator = ["C", "AC", "±", "%", "/", "x", "-", "+", "="]
    static let keysOfScientificOperators = [
        "( ", " )", "mc", "m+", "m-", "mr",
        "2nd", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x",
        "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10",
        "x!", "sin", "cos", "tan", "asin", "acos", "atan", "e", "EE",
        "Deg", "Rad", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh", "π", "Rand"]
    static let keysAll = [keysForDigits, [","], keysOfOperator, keysOfScientificOperators].joined()
    
    static let keysThatRequireValidNumber = ["±", "%", "/", "x", "-", "+", "=", "( ", " )", "m+", "m-", "mr", "x^2", "x^3", "x^y", "e^x", "y^x", "2^x", "10^x", "One_x", "√", "3√", "y√", "logy", "ln", "log2", "log10", "x!", "sin", "cos", "tan", "asin", "acos", "atan", "EE", "sinh", "cosh", "tanh", "asinh", "acosh", "atanh", "plusKey"]
    static let keysWithPendingOperations = ["y√", "x^y", "y^x", "logy", "x↑↑y", "EE"]
    static let keysThatDoNotNeedToBeDisabled = ["2nd", "Rad", "Deg"]

    static let fontWeight: UIFont.Weight = .thin // UIFont.Weight(rawValue: -4.02) is not continuous
    static var kerning: CGFloat = 0.0
    static let preliminaryDelay = 0.3 /// seconds
    static let sfImageforKey: [String: String] = [
        "+":   "plus",
        "-":   "minus",
        "x":   "multiply",
        "/":   "divide",
        "±": "plus.slash.minus",
        "=":   "equal",
        "%":   "percent",
    ]

}

extension Int {
    func remainderInWords(_ remainder: String) -> String {
        if remainder == "1" { return "one" }
        if remainder == "10" { return "ten" }
        return remainder
    }
    var useWords: String {
        let asString = "\(self)"
        if asString.hasSuffix("000000000000") {
            let remainder = String(asString.dropLast(12))
            if remainder.count < 4 {
                return remainderInWords(remainder) + " trillion"
            } else {
                return "\(self)"
            }
        }
        if asString.hasSuffix("000000000") {
            let remainder = String(asString.dropLast(9))
            if remainder.count < 4 {
                return remainderInWords(remainder) + " billion"
            } else {
                return "\(self)"
            }
        }
        if asString.hasSuffix("000000") {
            let remainder = String(asString.dropLast(6))
            if remainder.count < 4 {
                return remainderInWords(remainder) + " million"
            } else {
                return "\(self)"
            }
        }
        if asString.hasSuffix("000") {
            let remainder = String(asString.dropLast(3))
            if remainder.count < 4 {
                return remainderInWords(remainder) + " thousand"
            } else {
                return "\(self)"
            }
        }
        return "\(self)"
    }
    var asMemorySize: String {
        let d = Double(self)
        if d > 1e9 {
            return String(format: "%.1fGB", d / 1e9)
        }
        if d > 1e6 {
            return String(format: "%.1fMB", d / 1e6)
        }
        if d > 1e3 {
            return String(format: "%.1fKB", d / 1e3)
        }
        return String(format: "%.0f bytes", d)
    }}

extension Double {
    var asTime: String {
        if self < 1e-6 {
            return String(format: "%.1f microseconds", 1e6 * self)
        }
        if self < 1e-4 {
            return String(format: "%.1f microseconds", 1e6 * self)
        }
        if self < 0.1 {
            return String(format: "%.1f milliseconds", 1e3 * self)
        }
        if self < 0 {
            return String(format: "%.3f seconds", self)
        }
        if self < 10 {
            return String(format: "%.1f seconds", self)
        }
        if self < 60 {
            return String(format: "%.0f seconds", self)
        }
        return String(format: "%.1f hours", self/3600.0)
    }
}
