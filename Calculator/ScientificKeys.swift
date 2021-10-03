//
//  ScientificKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct ScientificKeys: View {
    @ObservedObject var brain: Brain
    let keySize: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat
    
    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("(", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("(") }
                Key(")", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(")") }
                Key("mc", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.notCalculating,
                        isPending: false)
                { brain.clearMemory() }
                Key("m+", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.addToMemory() }
                Key("m-", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.subtractFromMemory() }
                Key("mr", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.memory != nil && brain.notCalculating,
                        isPending: false,
                        isActive: brain.memory != nil)
                { brain.getMemory() }
            }
            HStack(spacing: horizontalSpace) {
                Key("2nd", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: brain.secondKeys)
                { brain.secondKeys.toggle() }
                Key("x^2", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x^2") }
                Key("x^3", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x^3") }
                Key("x^y", keyProperties: TE.LightGrayKeyProperties, isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("x^y"))
                { brain.operation("x^y") }
                Key(brain.secondKeys ? "y^x" : "e^x", keyProperties: TE.LightGrayKeyProperties, isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.secondKeys ? brain.inPlaceAllowed : brain.inPlaceAllowed,
                        isPending: brain.secondKeys ? brain.isPending("y^x") : false)
                { brain.operation(brain.secondKeys ? "y^x" : "e^x") }
                Key(brain.secondKeys ? "2^x" : "10^x", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(brain.secondKeys ? "2^x" : "10^x") }
            }
            HStack(spacing: horizontalSpace) {
                Key("One_x", keyProperties: TE.LightGrayKeyProperties, isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false,
                        isActive: brain.inPlaceAllowed)
                { brain.operation("One_x") }
                Key("√", keyProperties: TE.LightGrayKeyProperties, isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("√") }
                Key("3√", keyProperties: TE.LightGrayKeyProperties, isActive: brain.inPlaceAllowed)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("3√") }
                Key("y√", keyProperties: TE.LightGrayKeyProperties, isPending: brain.isPending("y√"), isActive: brain.inPlaceAllowed) // isPending for strokeColor
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.isPending("y√"))
                { brain.operation("y√") }
                Key(brain.secondKeys ? "logy" : "ln", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: brain.secondKeys ? brain.isPending("logy") : false)
                { brain.operation(brain.secondKeys ? "logy" : "ln") }
                Key(brain.secondKeys ? "log2" : "log10", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation(brain.secondKeys ? "log2" : "log10") }
            }
            HStack(spacing: horizontalSpace) {
                Key("x!", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                { brain.operation("x!") }
                Key(brain.secondKeys ? "asin" : "sin", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "asin" : "sin")
                    } else {
                        brain.operation(brain.secondKeys ? "asinD" : "sinD")
                    }
                }
                Key(brain.secondKeys ? "acos" : "cos", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "acos" : "cos")
                    } else {
                        brain.operation(brain.secondKeys ? "acosD" : "cosD")
                    }
                }
                Key(brain.secondKeys ? "atan" : "tan", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "atan" : "tan")
                    } else {
                        brain.operation(brain.secondKeys ? "atanD" : "tanD")
                    }
                }
                Key("e", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("e") }
                Key("EE", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("EE") }
            }
            HStack(spacing: horizontalSpace) {
                Key(brain.rad ? "Deg" : "Rad", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.notCalculating,
                        isPending: false)
                { brain.rad.toggle() }
                Key(brain.secondKeys ? "asinh" : "sinh", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "asinh" : "sinh")
                    } else {
                        brain.operation(brain.secondKeys ? "asinhD" : "sinhD")
                    }
                }
                Key(brain.secondKeys ? "acosh" : "cosh", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "acosh" : "cosh")
                    } else {
                        brain.operation(brain.secondKeys ? "acoshD" : "coshD")
                    }
                }
                Key(brain.secondKeys ? "atanh" : "tanh", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.inPlaceAllowed,
                        isPending: false)
                {   if brain.rad {
                        brain.operation(brain.secondKeys ? "atanh" : "tanh")
                    } else {
                        brain.operation(brain.secondKeys ? "atanhD" : "tanhD")
                    }
                }
                Key("π", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("π") }
                Key("Rand", keyProperties: TE.LightGrayKeyProperties)
                    .scientific(
                        size: keySize,
                        isAllowed: brain.digitsAllowed,
                        isPending: false)
                { brain.operation("rand") }
            }
        }
    }

    init(brain: Brain, t: TE) {
        self.brain = brain
        horizontalSpace = t.spaceBetweenkeys
        verticalSpace   = t.spaceBetweenkeys
        keySize = t.scientificKeySize
    }
}
