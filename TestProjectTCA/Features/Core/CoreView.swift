//
//  CoreView.swift
//  TestProjectTCA
//
//  Created by Yaroslav Golinskiy on 01/08/2025.
//

import SwiftUI
import ComposableArchitecture

struct CoreView: View {
    let store: StoreOf<CoreFeature>
    var body: some View {
       
        if !store.isLoggedIn {
            LoginView(store: store.scope(state: \.loginState,
                                         action: \.loginAction))
        } else {
            TabView(store: store.scope(state: \.tabState,
                                       action: \.tabAction))
        }
    }
}

@Reducer
struct CoreFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoggedIn: Bool = false
        var loginState: LoginFeature.State = .init()
        var tabState: TabFeature.State = .init()
    }
    
    enum Action {
        case setLogin
        case loginAction(LoginFeature.Action)
        case tabAction(TabFeature.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
         
        case .setLogin:
            state.isLoggedIn = true
            return .none
            
        case .loginAction(let action):
            
            if case .setLogin = action {
                state.isLoggedIn = true
            }
            
            let feature = LoginFeature().reduce(into: &state.loginState, action: action)
            return feature.map { .loginAction($0)}
            
        case .tabAction(let action):
            
            if case .counterAction(.setLogOut) = action {
                state.isLoggedIn = false
            }
            
            let feature = TabFeature().reduce(into: &state.tabState, action: action)
            return feature.map { .tabAction($0)}
        }
    }
}
