
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
