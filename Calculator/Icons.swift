//
//  Icons.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/17/22.
//

import SwiftUI

struct Icons : View {
    let simulatePurchased = true
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var store: Store
    @ObservedObject var viewModel: ViewModel
    let screen: Screen
    @Binding var isZoomed: Bool
    @State var copyDone = true
    @State var pasteDone = true
    @State var isValidPasteContent = true
    @State var wait300msDone = false

    var plus: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .font(Font.title.weight(.thin))
            .rotationEffect(isZoomed ? .degrees(-45.0) : .degrees(0.0))
            .frame(width: screen.plusIconSize, height: screen.plusIconSize)
            .background(.white)
            .foregroundColor(.gray)
            .clipShape(Circle())
            .animation(.linear, value: isZoomed)
            .onTapGesture {
                isZoomed.toggle()
            }
            .accessibilityIdentifier("plusButton")
    }
    
    @ViewBuilder
    var copy: some View {
        if !simulatePurchased && store.purchasedIDs.isEmpty {
            NavigationLink {
                PurchaseView(store: store, viewModel: viewModel, screen: screen, font: Font(screen.infoUiFont))
            } label: {
                Text("copy")
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        } else {
            Text("copy")
                .font(Font(screen.infoUiFont))
                .foregroundColor(viewModel.isCopying ? Color.orange : Color.white)
                .onTapGesture {
                    if copyDone && pasteDone && !viewModel.isCopying && !viewModel.isPasting {
                        setIsCopying(to: true)
                        wait300msDone = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            wait300msDone = true
                            if copyDone {
                                setIsCopying(to: false)
                            }
                        }
                        Task {
                            copyDone = false
                            await viewModel.copyToPastBin()
                            copyDone = true
                            if wait300msDone {
                                setIsCopying(to: false)
                            }
                        }
                        isValidPasteContent = true
                    }
                }
                .accessibilityIdentifier("copyButton")
        }
    }
    
    @ViewBuilder
    var paste: some View {
        if !simulatePurchased && store.purchasedIDs.isEmpty {
            NavigationLink {
                PurchaseView(store: store, viewModel: viewModel, screen: screen, font: Font(screen.infoUiFont))
            } label: {
                Text("paste")
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        } else {
            Text("paste")
                .font(Font(screen.infoUiFont))
                .foregroundColor(isValidPasteContent ? (viewModel.isPasting ? .orange : .white) : .gray)
                .onTapGesture {
                    if copyDone && pasteDone && !viewModel.isCopying && !viewModel.isPasting && isValidPasteContent {
                        setIsPasting(to: true)
                        pasteDone = false
                        wait300msDone = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            wait300msDone = true
                            if pasteDone {
                                viewModel.isPasting = false
                            }
                        }
                        Task {
                            isValidPasteContent = await viewModel.copyFromPasteBin(screen: screen)
                            pasteDone = true
                            if wait300msDone {
                                setIsPasting(to: false)
                            }
                        }
                    }
                }
                .accessibilityIdentifier("pasteButton")
        }
    }
    
    var settings: some View {
        NavigationLink {
            Settings(viewModel: viewModel, screen: screen, font: Font(screen.infoUiFont))
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(Font.title.weight(.thin))
                .frame(height: screen.plusIconSize * 0.6)
                .foregroundColor(Color.white)
                .accessibilityIdentifier("settingsButton")
        }
    }
    
    @ViewBuilder
    var toInt: some View {
        let integerLabel = viewModel.currentDisplay.data.canBeInteger ? (viewModel.showAsInteger ? "→ sci" : "→ int") : ""
        if integerLabel.count > 0 {
            Button {
                viewModel.showAsInteger.toggle()
                Task {
                    await viewModel.refreshDisplay(screen: screen)
                }
            } label: {
                Text(integerLabel)
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        }
    }
    
    @ViewBuilder
    var toFloat: some View {
        let floatLabel = viewModel.currentDisplay.data.canBeFloat ? (viewModel.showAsFloat ? "→ sci" : "→ float") : ""
        if !viewModel.currentDisplay.data.canBeInteger && floatLabel.count > 0 {
            Button {
                viewModel.showAsFloat.toggle()
                Task {
                    await viewModel.refreshDisplay(screen: screen)
                }
            } label: {
                Text(floatLabel)
                    .font(Font(screen.infoUiFont))
                    .foregroundColor(Color.white)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.0) {
            plus
            Group {
                copy
                paste
                settings
                toInt
                toFloat
            }
            .padding(.top, screen.plusIconSize * 0.5)
            .lineLimit(1)
            .minimumScaleFactor(0.01) // in case "paste" is too wide on small phones
        }
        .frame(width: screen.plusIconSize)
        .padding(.leading, screen.plusIconLeftPadding)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                self.isValidPasteContent = true
            }
        }
    }
    @MainActor func setIsCopying(to isCopying: Bool) {
        viewModel.isCopying = isCopying
    }
    @MainActor func setIsPasting(to isPasting: Bool) {
        viewModel.isPasting = isPasting
    }
}
//struct Icons_Previews: PreviewProvider {
//    static var previews: some View {
//        Icons()
//    }
//}
