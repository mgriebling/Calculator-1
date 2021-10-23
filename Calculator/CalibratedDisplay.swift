//
//  CalibratedDisplay.swift
//  Calculator
//
//  Created by Joachim Neumann on 10/22/21.
//

import SwiftUI

struct NonScientificDisplay: View {
    @Binding var scrollTarget: Int?
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        if let nonScientific = brain.nonScientific {
            let len: Int = nonScientific.count
            let text = (len > 1000) ?
            String(nonScientific.prefix(1000)) + "...\n\nCopy to get \(TE.highPrecisionString)" : nonScientific
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    Text(text)
                        .font(t.displayFont)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(TE.DigitKeyProperties.textColor)
                        .font(t.displayFont)
                        .multilineTextAlignment(.trailing)
                        .id(1)
                }
                .disabled(!brain.zoomed)
                .onChange(of: scrollTarget) { target in
                    if let target = target {
                        scrollTarget = nil
                        withAnimation {
                            scrollViewProxy.scrollTo(target, anchor: .top)
                        }
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct ScientificDisplay: View {
    @Binding var scrollTarget: Int?
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        if let scientific = brain.scientific {
            HStack(spacing: 0.0) {
                let len = scientific.mantissa.count
                let text = (len > 1000) ?
                String(scientific.mantissa.prefix(1000)) + "...\n\nCopy to get \(TE.highPrecisionString)" :
                scientific.mantissa
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        Text(text)
                            .font(t.displayFont)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(TE.DigitKeyProperties.textColor)
                            .multilineTextAlignment(.trailing)
                            .id(1)
                    }
                    .disabled(!brain.zoomed)
                    .onChange(of: scrollTarget) { target in
                        if let target = target {
                            scrollTarget = nil
                            withAnimation {
                                scrollViewProxy.scrollTo(target, anchor: .top)
                            }
                        }
                    }
                }
                VStack(spacing: 0.0) {
                    Text(" "+scientific.exponent)
                        .font(t.displayFont)
                        .foregroundColor(TE.DigitKeyProperties.textColor)
                        .lineLimit(1)
                    Spacer(minLength: 0.0)
                }
            }
        } else {
            EmptyView()
        }
    }
}

struct CalibratedDisplay: View {
    @Binding var scrollTarget: Int?
    @ObservedObject var brain: Brain
    let t: TE
    var body: some View {
        Group {
            if brain.displayAsString || brain.displayAsInteger || brain.displayAsFloat {
                NonScientificDisplay(scrollTarget: $scrollTarget, brain: brain, t: t)
            } else {
                ScientificDisplay(scrollTarget: $scrollTarget, brain: brain, t: t)
            }
        }
        .offset(x: 0, y: -0.03*t.displayFontSize)
        .contextMenu {
            Button(action: {
                if brain.nonScientific != nil && (brain.displayAsString || brain.displayAsInteger || brain.displayAsFloat ) {
                    UIPasteboard.general.string = brain.nonScientific!
                } else {
                    UIPasteboard.general.string = brain.scientific?.combined
                }
            }) {
                Text("Copy to clipboard")
                Image(systemName: "doc.on.doc")
            }
            if UIPasteboard.general.hasStrings {
                Button(action: {
                    brain.fromPasteboard()
                }) {
                    Text("Paste from clipboard")
                    Image(systemName: "doc.on.clipboard")
                }
            }
        }    }
}
