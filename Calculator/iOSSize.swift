//
//  iOSSize.swift
//  Calculator
//
//  Created by Joachim Neumann on 02/10/2021.
//

#if targetEnvironment(macCatalyst)
// nothing to compile here...
#else

import SwiftUI

struct iOSSize: View {
    let brain: Brain
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let windowCandidate = UIApplication
                    .shared
                    .connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }
                
                let insets = windowCandidate!.safeAreaInsets

                let leadingPaddingNeeded  = insets.left   == 0
                let trailingPaddingNeeded = insets.right  == 0
                let bottomPaddingNeeded   = insets.bottom == 0
                
                let horizontalFactor:CGFloat = 1.0 -
                (leadingPaddingNeeded ? TE.spacingFration : 0) -
                (trailingPaddingNeeded ? TE.spacingFration : 0 )
                let verticalFactor:CGFloat = 1.0 -
                (bottomPaddingNeeded ? TE.spacingFration : 0.0)
                
                let appFrame = CGSize(
                    width: geo.size.width * horizontalFactor,
                    height: geo.size.height * verticalFactor)
                
                let t = TE(appFrame: appFrame)
                
                /// make the app frame smaller if there is no safe area.
                /// If there already is safe area, no padding is needed
                ContentView(brain: brain, t: t)
                    .padding(.leading, leadingPaddingNeeded ? t.spaceBetweenkeys : 0)
                    .padding(.trailing, trailingPaddingNeeded ? t.spaceBetweenkeys : 0)
                    .padding(.bottom, bottomPaddingNeeded ? t.spaceBetweenkeys : 0)
            }
        }
    }
}

#endif
