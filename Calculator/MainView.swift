//
//  MainView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

/*
 iPhone portrait: no "+", only Single Line Display
 iPhone landscape: "+" and Single Line Display above keyboard. Expand: keyboard disappears
 iPad portrait:    "+" and Single Line Display above keyboard. Expand: above keyboard
 iPad landscape:   "+" and Single Line Display above keyboard. keyboard less high (50% of screen). Expand: above keyboard
 Mac: change window size?
 */
import SwiftUI

struct MainView: View {
    @ObservedObject var brain: Brain
    @State private var isZoomed = false
    var t: TE
    
    var body: some View {
        let trailingAfterDisplay = (t.isPad || !t.isPortrait) ? t.iconSize * 1.2 : 0.0
        ZStack {
            /// Icons - except for portrait iPhone
            if t.isPad || !t.isPortrait {
                VStack(spacing: 0.0) {
                    HStack(spacing: 0.0) {
                        Spacer()
                        VStack(spacing: 0.0) {
                            PlusIcon(brain: brain, t: t, isZoomed: $isZoomed)
                            ControlIcon(brain: brain, t: t, isZoomed: $isZoomed)
                        }
                    }
                    Spacer()
                }
            }
            
            if t.isPad {
                VStack(spacing: 0.0) {
                    Spacer(minLength: 0.0)
                    if isZoomed {
                        MultiLineDisplay(brain: brain, t: t)
                            .padding(.trailing, trailingAfterDisplay)
                    } else {
                        SingleLineDisplay(brain: brain, t: t)
                            .padding(.trailing, trailingAfterDisplay)
                    }
                    Keys(brain: brain, t: t)
                }
            } else {
                VStack(spacing: 0.0) {
                    if isZoomed {
                        MultiLineDisplay(brain: brain, t: t)
                            .padding(.trailing, trailingAfterDisplay)
                    } else {
                        Spacer(minLength: 0.0)
                        SingleLineDisplay(brain: brain, t: t)
                            .padding(.trailing, trailingAfterDisplay)
                        Keys(brain: brain, t: t)
                    }
                }
            }
            
            
            /// Display and Keys
            if !t.isPad && false {
                /// iPhone
                if t.isPortrait {
                    /// no zoom
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        SingleLineDisplay(brain: brain, t: t)
                        Keys(brain: brain, t: t)
                    }
                } else {
                    if !isZoomed {
                        VStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            HStack(spacing: 0.0) {
                                SingleLineDisplay(brain: brain, t: t)
                            }
                            Keys(brain: brain, t: t)
                        }
                    } else {
                        /// iPhone landscape zoomed
                        HStack(spacing: 0.0) {
                            MultiLineDisplay(brain: brain, t: t)
                        }
                    }
                }
            } else {
                /// iPad or Mac
            }
        }
        
        
        /*
         VStack(spacing: 0.0) {
         Spacer(minLength: 0.0)
         HStack(spacing: 0.0) {
         if !isZoomed || !t.isZoomAllowed {
         SingleLineDisplay(brain: brain, t: t)
         } else {
         MultiLineDisplay(brain: brain, t: t)
         }
         if t.isPad || !t.isPortrait {
         VStack(spacing: 0.0) {
         PlusIcon(brain: brain, t: t, isZoomed: $isZoomed)
         if isZoomed && t.isZoomAllowed  {
         Image(systemName: "switch.2")
         .resizable()
         .scaledToFit()
         .frame(width: t.iconSize, height: t.iconSize)
         .font(.system(size: t.iconSize*0.75, weight: .thin))
         .padding(.top, t.iconSize*0.25)
         .foregroundColor(t.digits_1_9.textColor)
         .onTapGesture {
         withAnimation() {
         }
         }
         .padding(.top, t.iconSize*0.2)
         }
         Spacer(minLength: 0.0)
         }
         //                    .padding(.top, t.iconSize*0.2)
         //                    .padding(.leading, t.iconSize * TE.iconLeadingPadding)
         ////                    .frame(height: t.displayheight + (isZoomed && t.isZoomAllowed ? t.allkeysHeight : 0.0), alignment: .topTrailing)
         }
         }
         if !isZoomed || !t.isZoomAllowed {
         Keys(brain: brain, t: t)
         }
         }
         */
    }
    
    
    struct Keys: View {
        let brain: Brain
        var t: TE
        var body: some View {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                HStack(spacing: 0.0) {
                    if t.isPad || !t.isPortrait {
                        ScientificKeys(brain: brain, t: t)
                            .padding(.trailing, t.spaceBetweenKeys)
                    }
                    NumberKeys(brain: brain, t: t)
                }
            }
            .frame(height: t.allkeysHeight)
            .transition(.move(edge: .bottom))
        }
    }
    
    struct Rad: View {
        let keySize: CGSize
        let textColor: Color
        var body: some View {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                Text("Rad")
                    .font(Font.system(size: keySize.height*0.27).monospacedDigit())
                //.foregroundColor(Color.yellow)
                    .padding(.leading, keySize.height*0.27)
                    .padding(.bottom, keySize.height*0.1)
            }
        }
    }
    
}

