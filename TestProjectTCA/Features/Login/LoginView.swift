//
//  LoginView.swift
//  TestProjectTCA
//
//  Created by Yaroslav Golinskiy on 01/08/2025.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    
    var body: some View {
        VStack {
            TextField("Name", text: Binding(get: {store.name},
                                            set: {store.send(.changeName($0))}))
            .textFieldStyle(.roundedBorder)
            
            Button("Login") {
                store.send(.setLogin)
            }
            .frame(maxWidth: .infinity)
            .border(store.isValidEmail ? .blue : .red)
        }
        .padding()
    }
}

@Reducer
struct LoginFeature {
    
    @ObservableState
    struct State: Equatable {
        var name: String = ""
        var isValidEmail: Bool = false
        var isLoggedIn: Bool = false
    }
    
    enum Action: Equatable {
        case changeName(String)
        case setLogin
        case checkValid
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .changeName(let name):
            state.name = name
            return .send(.checkValid)
            
        case .checkValid:
            state.isValidEmail = !state.name.isEmpty
            return .none
        case .setLogin:
            state.isLoggedIn = true
            return .none
        }
    }
}
