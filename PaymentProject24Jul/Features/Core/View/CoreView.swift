//
//  CoreView.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct CoreView: View {
    let store: StoreOf<CoreFeature>
    
    var body: some View {
        if !store.isLoggedIn {
            LoginView( store: store.scope( state: \.loginState, action: \.loginAction) )
        } else {
            TabView(store: store.scope(state: \.tabState, action: \.tabAction))
        }
    }
}
