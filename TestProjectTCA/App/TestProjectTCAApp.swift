//
//  TestProjectTCAApp.swift
//  TestProjectTCA
//
//  Created by Yaroslav Golinskiy on 31/07/2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct TestProjectTCAApp: App {
    var body: some Scene {
        WindowGroup {
            CoreView(store: Store(initialState: CoreFeature.State(), reducer: {
                CoreFeature()
            }))
        }
    }
}
