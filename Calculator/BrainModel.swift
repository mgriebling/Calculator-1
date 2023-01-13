//
//  BrainModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import SwiftUI

protocol KeyPressResponder {
    var forceScientific: Bool { get }
    var showAsInteger: Bool { get }
    var showAsFloat: Bool { get }
    func keyPress(_ symbol: String) async -> CalculationResult
    func copyFromPasteBin() async -> CalculationResult?
}

class BrainModel : KeyPressResponder, ObservableObject {
    @Published internal var showAsInteger = false /// This will update the "-> Int or -> sci button texts
    @Published internal var showAsFloat = false
    private let timerDefaultText = "click to measure"
    private var timer: Timer? = nil
    private var timerCounter = 0
    private var timerInfo: String = ""

    @Published var isCopying: Bool = false
    @Published var isPasting: Bool = false
    
    private let brain: Brain
    //    private let stupidBrain: Brain
    //    private let stupidBrainPrecision = 100
    
    var precisionDescription = "unknown"
    
    @AppStorage("precision", store: .standard) private (set) var precision: Int = 1000
    @AppStorage("forceScientific", store: .standard) var forceScientific: Bool = false
    @AppStorage("memoryValue", store: .standard) var memoryValue: String = ""
    static let MAX_DISPLAY_LEN = 10_000 // too long strings in Text() crash the app
    
    init() {
        brain = Brain(precision: _precision.wrappedValue)
        precisionDescription = _precision.wrappedValue.useWords
    }
    
    func keyPress(_ symbol: String) async -> CalculationResult {
        let result = await brain.operation(symbol)
        return result
    }
    
    // the update of the precision in brain can be slow.
    // Therefore, I only want to do that when leaving the settings screen
    func updatePrecision(to newPecision: Int) async {
        await MainActor.run {
            precision = newPecision
            precisionDescription = self.precision.useWords
        }
        let _ = await brain.setPrecision(newPecision)
    }
    
    func copyFromPasteBin() async -> CalculationResult? {
        var calculationResult: CalculationResult? = nil
        if UIPasteboard.general.hasStrings {
            if let pasteString = UIPasteboard.general.string {
                print("pasteString", pasteString, pasteString.count)
                if pasteString.count > 0 {
                    if Gmp.isValidGmpString(pasteString, bits: 1000) {
                        calculationResult = await brain.replaceLast(with: Number(pasteString, precision: brain.precision))
                    }
                }
            }
        }
        return calculationResult
    }
    
    
    func checkIfPasteBinIsValidNumber() -> Bool {
        if UIPasteboard.general.hasStrings {
            if let pasteString = UIPasteboard.general.string {
                if pasteString.count > 0 {
                    if Gmp.isValidGmpString(pasteString, bits: 1000) {
                        return true
                    }
                }
            }
        }
        return false
    }
}


class ParkBenchTimer {
    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?
    
    init() {
        //print("ParkBenchTimer init()")
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func stop() -> Double {
        endTime = CFAbsoluteTimeGetCurrent()
        return duration!
    }
    var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
