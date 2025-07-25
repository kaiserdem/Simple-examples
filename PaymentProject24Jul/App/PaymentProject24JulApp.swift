//
//  PaymentProject24JulApp.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 24/07/2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct PaymentProject24JulApp: App {
    var body: some Scene {
        WindowGroup {
            CoreView(store: Store(initialState: CoreFeature.State(), reducer: {
                CoreFeature()
            }))
        }
    }
}
