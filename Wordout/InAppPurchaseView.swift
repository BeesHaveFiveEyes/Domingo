//
//  InAppPurchaseView.swift
//  Wordout
//
//  Created by Alasdair Casperd on 17/11/2022.
//

import StoreKit
import SwiftUI

struct InAppPurchaseView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager

    var body: some View {
        NavigationView {
            VStack(alignment: .center){
                switch unlockManager.requestState {
                case .loaded(let product):
                    FullUnlockView(product: product)
                case .failed(_):
                    Text("Could not reach the store. Please try again later.")
                    Spacer()
                    Button("Dismiss", action: dismiss)
                case .loading:
                    ProgressView("Loading…")
                    Spacer()
                    Button("Dismiss", action: dismiss)
                case .purchased:
                    Text("Thank you for supporting \(WordoutApp.appName)!")
                    Spacer()
                    Button("Dismiss", action: dismiss)
                case .deferred:
                    Text("Thank you! Your request is pending approval. You can carry on using the rest of the app while you wait.")
                    Spacer()
                    Button("Dismiss", action: dismiss)
                }
            }
            .navigationTitle("Full Unlock")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss)
                }
            }
        }
        .onReceive(unlockManager.$requestState) { value in
            if case .purchased = value {
                dismiss()
            }
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
