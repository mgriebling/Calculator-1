//
//  IOSContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

import SwiftUI

#if targetEnvironment(macCatalyst)
// nothing to compile here...
#else
struct IOSContentView: View {
    @ObservedObject var brain = Brain()
    @State var zoomed: Bool = false
    @State var copyPasteHighlight = false
    @State var leadingPaddingNeeded: Bool = false
    @State var trailingPaddingNeeded: Bool = false
    @State var bottomPaddingNeeded: Bool = false

    func calculatePadding() {
        let windowCandidate = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if windowCandidate != nil { insets = windowCandidate!.safeAreaInsets }
        leadingPaddingNeeded  = (insets.left   == 0)
        trailingPaddingNeeded = (insets.right  == 0)
        bottomPaddingNeeded   = (insets.bottom == 0)
    }
    
    var body: some View {
        return ZStack {
            GeometryReader { geo in
                
                /// make the app frame smaller if there is no safe area.
                /// If there already is safe area, no padding is needed
                let horizontalFactor:CGFloat = 1.0 -
                (leadingPaddingNeeded   ? Configuration.spacingFration : 0) -
                (trailingPaddingNeeded  ? Configuration.spacingFration : 0 )
                let verticalFactor:CGFloat = 1.0 -
                (bottomPaddingNeeded ? Configuration.spacingFration : 0.0)

                let appFrame = CGSize(
                    width: geo.size.width * horizontalFactor,
                    height: geo.size.height * verticalFactor)
                let c = Configuration(appFrame: appFrame)
                
                VStack {
                    Spacer(minLength: 0)
                    HStack(spacing: 0) {
                        Spacer(minLength: leadingPaddingNeeded ? c.spaceBetweenkeys : 0)
                        ScientificKeys(
                            brain: brain, c: c)
                            .frame(width: c.scientificPadWidth, height: c.allKeysHeight)
                            .background(Color.orange)
                        Spacer(minLength: c.spaceBetweenkeys)
                        NumberKeys(
                            brain: brain, c: c)
                            .background(Color.orange)
                            .frame(width: c.numberPadWidth, height: c.allKeysHeight)
                        Spacer(minLength: trailingPaddingNeeded ? c.spaceBetweenkeys : 0)
                    }
                    .background(Color.green)
                }
                .padding(.bottom, bottomPaddingNeeded ? c.spaceBetweenkeys : 0)
            }
        }
        .onRotate() { calculatePadding() }
        
        //            LandscapeKeys(brain: brain)
        //        }
        //    }
        
        
        //            if let appFrame = appFrame {
        //                if appFrame.width > 1.0 {
        //                    let _ = print("content: appFrame=\(appFrame)")
        //                    if zoomed && brain.hasMoreDigits {
        //                        AllDigitsView(
        //                            brain: brain,
        //                            textColor: copyPasteHighlight ? Color.orange : Configuration.DigitKeyProperties.textColor)
        //                            .padding(.trailing, Configuration.numberKeySize(appFrame: appFrame).width)
        //                            .padding(.leading, 10)
        //                    } else {
        //                        ZStack {
        //                            VStack {
        ////                                Display(
        ////                                    text: brain.display,
        ////                                    textColor: copyPasteHighlight ? Color.orange : Configuration.DigitKeyProperties.textColor)
        ////                                    .padding(.trailing, Configuration.numberKeySize(appFrame: appFrame).width)
        //                                Spacer(minLength: 0)
        //                                if !zoomed {
        //                                    LandscapeKeys(brain: brain, appFrame: appFrame)
        //                                        .transition(.move(edge: .bottom))
        //                                }
        //                            }
        //                            if brain.rad && !zoomed {
        //                                Rad()
        //         let radSize = Configuration.shared.displayFontSize*0.25
        //         let yPadding = Configuration.shared.displayFontSize - radSize*1.4
        
        //                                    .transition(.move(edge: .bottom))
        //                            }
        //                        }
        //                        .transition(.move(edge: .bottom))
        //                    }
        //                    HStack(spacing: 0) {
        //                        Spacer(minLength: 0)
        //                        // from here on: trailing
        //                        VStack(spacing: 0) {
        //                            HStack(spacing: 0) {
        //                                Spacer(minLength: 0)
        //                                Zoom(active: brain.hasMoreDigits, zoomed: $zoomed, showCalculating: brain.showCalculating)
        //                                    .padding(.top, 12) // hardcoded. The correct height depends on the display font and I was lazy...
        //                                Spacer(minLength: 0)
        //                            }
        //                            if zoomed {
        //                                Copy(longString: brain.combinedLongDisplayString(longDisplayString: brain.longDisplayString)) {
        //                                    copyPasteHighlight = true
        //                                    let now = DispatchTime.now()
        //                                    var whenWhen: DispatchTime
        //                                    whenWhen = now + DispatchTimeInterval.milliseconds(300)
        //                                    DispatchQueue.main.asyncAfter(deadline: whenWhen) {
        //                                        copyPasteHighlight = false
        //                                    }
        //                                }
        //                                .padding(.top, 40)
        //                                Paste() { fromPasteboard in
        //                                    copyPasteHighlight = true
        //                                    let now = DispatchTime.now()
        //                                    var whenWhen: DispatchTime
        //                                    whenWhen = now + DispatchTimeInterval.milliseconds(300)
        //                                    DispatchQueue.main.asyncAfter(deadline: whenWhen) {
        //                                        copyPasteHighlight = false
        //                                    }
        //                                    brain.fromPasteboard(fromPasteboard)
        //                                }
        //                                .padding(.top, 20)
        //                            }
        //                            Spacer()
        //                        }
        //                        //                        .frame(maxWidth: Configuration.numberKeySize(appFrame: appFrame).width+3)
        //                    }
        //                }
        //            }
        
    }
}


struct IOSContentView_Previews: PreviewProvider {
    static var previews: some View {
        IOSContentView()
    }
}
#endif


//                FrameCatcher(into: $frameSize)
//                if zoomed {
//                    VStack {
//                        AllDigitsView(brain: brain, textColor: Color.white)
//                            .padding(.trailing, 15)
//                            .padding(.leading, 60)
//                        Spacer()
//                    }
//                } else {
//                    VStack {
//                        Spacer()
//                        Display(
//                            text: brain.display,
//                            textColor: Configuration.DigitKeyProperties.textColor)
//                            .padding(.trailing, 15)
//                        NumberKeys(brain: brain, keySize: Configuration.keySize())
//                    }
//                    .transition(.move(edge: .bottom))
//                }
//                Zoom(active: brain.hasMoreDigits, zoomed: $zoomed, showCalculating: false)
//            }
//            .padding(.top, 28)
//            .padding(.bottom, 28)
//            .padding()

struct DeviceRotationViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action()
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
