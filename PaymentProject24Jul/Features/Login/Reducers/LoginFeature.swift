//
//  LoginFeature.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LoginFeature {
    
    @ObservableState
    struct State: Equatable {
        var email: String = ""
        var loggidenIn: Bool = false
        var isValidEmail: Bool = false
    }
    
    enum Action {
        case setEmail(String)
        case checkValidEmail
        case setLogin
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .setEmail(let email):
            state.email = email
            return .send(.checkValidEmail)
            
        case .checkValidEmail:
            state.isValidEmail = !state.email.isEmpty
            return .none
            
        case .setLogin:
            state.loggidenIn = true
            return .none
        }
    }
}
