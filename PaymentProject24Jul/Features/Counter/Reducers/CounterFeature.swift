//
//  CounterFeature.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        var count: Int = 0
        var isLoading: Bool = false
        var isTimerRunning: Bool = false
        var history: [Int] = []
        var showErrroAlert: Bool = false
        var errorMessage: String? = nil
        var step: Int = 1
        var isLogoutIn: Bool = false
    }
    
    enum Action {
        case increment
        case incrementAsync(Int)
        case decrement
        case decrementAsync(Int)
        case timerTick
        case timerToggle
        case error(String)
        case dismissErrorAlert
        case addToHistory(Int)
        case setStep(Int)
        case setLogout
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.counterEffect) var effectAsync
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        
        switch action {
            
        case .timerToggle:
            state.isTimerRunning.toggle()
            if state.isTimerRunning {
                
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelId.timer)
                
            } else {
                return .cancel(id: CancelId.timer)
            }
            
            
        case .incrementAsync(let count):
            state.isLoading = false
            state.count  = count
            return .send(.addToHistory(state.count))
            
        case .increment:
            state.isLoading = true
            let count = state.count
            let step = state.step
            
            return .run { send in
                do  {
                    let effect = try await effectAsync.incrementAsync(step, count)
                    await send(.incrementAsync(effect))
                    
                } catch {
                    await send(.error(error.localizedDescription))
                }
            }
            
        case .decrement:
            state.isLoading = true
            let count = state.count
            let step = state.step
            
            return .run { send in
                do {
                    
                    let effect = try await effectAsync.decrementAsync(step, count)
                    await send(.decrementAsync(effect))
                } catch {
                    await send(.error(error.localizedDescription))
                }
            }
            
            
        case .decrementAsync(let count):
            state.count = count
            state.isLoading = false
            return .send(.addToHistory(state.count))
            
        case .timerTick:
            state.count += state.step
            return .send(.addToHistory(state.count))
            
        case .addToHistory(let value):
            state.history.append(value)
            return .none
            
        case .setStep(let step):
            state.step = step
            return .none
            
        case .error(let error):
            state.isLoading = false
            state.showErrroAlert = true
            state.errorMessage = error
            print("Error: \(error)")
            return .none
            
        case .dismissErrorAlert:
            state.errorMessage = nil
            state.showErrroAlert = false
            return .none
            
        case .setLogout:
            state.isLogoutIn = true
            return .none
        }
    }
}
