//
//  ContentView.swift
//  TestProjectTCA
//
//  Created by Yaroslav Golinskiy on 31/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        ZStack {
            VStack {
                
                Button("Log Out") {
                    store.send(.setShowLogOutView(true))
                }
                .frame(maxWidth: .infinity)
                .border(.fill)
                
                Spacer()
                
                ZStack {
                    if store.isLoading {
                        ProgressView()
                    } else {
                        Text("\(store.count)")
                    }
                }
                .frame(height: 40)
                HStack {
                    Button("+") {
                        store.send(.increment)
                    }
                    
                    Button("-") {
                        store.send(.decrement)
                    }
                }
                
                Button(store.isTimerRunning ? "Stop" : "Start") {
                    store.send(.timerToggle)
                }
                
                Spacer()
            }
            .blur(radius: store.showLogOutView ? 8 : 0)
            .padding()
            .alert("Error", isPresented: Binding(
                get: { store.showErrorAlert },
                set: { _ in store.send(.dissmisErrorAlert)}
            )) {
                Button("Ok") {
                    store.send(.dissmisErrorAlert)
                }
            } message : {
                Text("\(store.errorMessage ?? "")")
            }
            
            if store.showLogOutView {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    LogOutBanner(count: store.count) {
                        store.send(.setLogOut)
                    } onCancel: {
                        store.send(.setShowLogOutView(false))
                    }

                    Spacer()
                }
                .transition(.scale)
                .zIndex(1)
            }
        }
        .animation(.easeInOut, value: store.showLogOutView)
    }
}

struct LogOutBanner: View {
    let count: Int
    let onAccept: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack {
            
            Text("Log out")
            
            Text("Current counter: \(count)")
            
            Text("After logout all your data will be lost")
            
            HStack(spacing: 16) {
                Button("Cancel") {
                    onCancel()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.9))
                .foregroundColor(.primary)
                .cornerRadius(8)
               
                
                Button("Accept Log Out") {
                    onAccept()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}
