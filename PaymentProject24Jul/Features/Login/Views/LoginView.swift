//
//  LoginView.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginFeature>
    var body: some View {
        
        VStack {
            Text("Login")
                .font(.largeTitle)
            
            Spacer()
            
            TextField("Email", text: .init(
                get: {store.email},
                set: {store.send(.setEmail($0))}))
            .border(.gray)
            
            Button("Login") {
                store.send(.setLogin)
            }
            .frame(maxWidth: .infinity)
            .border(store.isValidEmail ? .green : .gray)
            .disabled(!store.isValidEmail)
            
            Spacer()
            
        }
        .padding()
        
    }
}
