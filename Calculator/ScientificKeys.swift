//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var brain: Brain
    let size: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("(")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("(") }
                Key(")")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(")") }
                Key("mc")
                    .scientific(
                        size: size,
                        isAllowed: true,
                        isPending: false)
                { brain.clearMemory() }
                Key("m+")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.addToMemory() }
                Key("m-")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.subtractFromMemory() }
                Key("mr")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.getMemory() }
            }
            HStack(spacing: horizontalSpace) {
                Key("2nd")
                    .scientific(
                        size: size,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.secondKeys.toggle() }
                Key("x^2")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x^2") }
                Key("x^3")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x^3") }
                Key("x^y")
                    .scientific(
                        size: size,
                        isAllowed: brain.digitsAllowed,
                        isPending: brain.isPending("x^y"))
                { brain.operation("x^y") }
                Key(brain.secondKeys ? "y^x" : "e^x")
                    .scientific(
                        size: size,
                        isAllowed: brain.secondKeys ? brain.digitsAllowed : brain.inPlaceAllowed,
                        isPending: brain.secondKeys ? brain.isPending("y^x") : false)
                { brain.operation(brain.secondKeys ? "y^x" : "e^x") }
                Key(brain.secondKeys ? "2^x" : "10^x")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(brain.secondKeys ? "2^x" : "10^x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("One_x")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("One_x") }
                Key("√")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("√") }
                Key("3√")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("3√") }
                Key("y√")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("y√"))
                { brain.operation("y√") }
                Key(brain.secondKeys ? "logy" : "ln")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.secondKeys ? brain.isPending("logy") : false)
                { brain.operation(brain.secondKeys ? "logy" : "ln") }
                Key(brain.secondKeys ? "log2" : "log10")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(brain.secondKeys ? "log2" : "log10") }
            }
            HStack(spacing: horizontalSpace) {
                Key("x!")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x!") }
                Key(brain.secondKeys ? "asin" : "sin")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "asin" : "sin")
                    } else {
                        brain.operation(brain.secondKeys ? "asinD" : "sinD")
                    }
                }
                Key(brain.secondKeys ? "acos" : "cos")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "acos" : "cos")
                    } else {
                        brain.operation(brain.secondKeys ? "acosD" : "cosD")
                    }
                }
                Key(brain.secondKeys ? "atan" : "tan")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "atan" : "tan")
                    } else {
                        brain.operation(brain.secondKeys ? "atanD" : "tanD")
                    }
                }
                Key("e")
                    .scientific(
                        size: size,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("e") }
                Key("EE")
                    .scientific(
                        size: size,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("EE") }
            }
            HStack(spacing: horizontalSpace) {
                Key(brain.rad ? "Deg" : "Rad")
                    .scientific(
                        size: size,
                        isAllowed: true,
                        isPending: false)
                { brain.rad.toggle() }
                Key(brain.secondKeys ? "asinh" : "sinh")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "asinh" : "sinh")
                    } else {
                        brain.operation(brain.secondKeys ? "asinhD" : "sinhD")
                    }
                }
                Key(brain.secondKeys ? "acosh" : "cosh")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "acosh" : "cosh")
                    } else {
                        brain.operation(brain.secondKeys ? "acoshD" : "coshD")
                    }
                }
                Key(brain.secondKeys ? "atanh" : "tanh")
                    .scientific(
                        size: size,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "atanh" : "tanh")
                    } else {
                        brain.operation(brain.secondKeys ? "atanhD" : "tanhD")
                    }
                }
                Key("π")
                    .scientific(
                        size: size,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("π") }
                Key("Rand")
                    .scientific(
                        size: size,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("rand") }
            }
        }
    }

    init(brain: Brain, keyWidth: CGFloat, keyHeight: CGFloat) {
        self.brain = brain
        horizontalSpace = Configuration.shared.horizontalSpace(forTotalWidth: keyWidth)
        verticalSpace   = Configuration.shared.verticalSpace(forTotalWidth: keyHeight)
        size = CGSize(width: keyWidth, height: keyHeight)
    }
}

struct ScientificKeys_Previews: PreviewProvider {
    static var previews: some View {
        ScientificKeys(brain: Brain(), keyWidth: 50, keyHeight: 30)
    }
}
