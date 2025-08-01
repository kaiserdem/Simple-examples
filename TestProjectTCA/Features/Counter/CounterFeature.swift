//
//  CounterFeature.swift
//  TestProjectTCA
//
//  Created by Yaroslav Golinskiy on 01/08/2025.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        var count: Int = 0
        var isTimerRunning: Bool = false
        var isLoading: Bool = false
        var errorMessage: String? = nil
        var showErrorAlert: Bool = false
        var isLogOut: Bool = false
        var showLogOutView: Bool = false
    }
    
    
    enum Action {
        case increment
        case incrementAsync(Int)
        case decrement
        case decrementAsync(Int)
        case timerTick
        case timerToggle
        case error(String)
        case dissmisErrorAlert
        case setLogOut
        case setShowLogOutView(Bool)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.conterEffect) var conterEffect
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .increment:
            state.isLoading = true
            
            return .run { [count = state.count] send in
                do  {
                    let effect = try await conterEffect.increment(count: count)
                    await send(.incrementAsync(effect))
                } catch {
                    await send(.error(error.localizedDescription))
                }
            }
            
        case .incrementAsync(let count):
            state.isLoading = false
            state.count = count
            return .none
            
        case .decrement:
            state.isLoading = true
            
            return .run { [count = state.count] send in
                do {
                    let effect = try await conterEffect.decrement(count: count)
                    await send(.decrementAsync(effect))
                } catch {
                    await send(.error(error.localizedDescription))
                }
            }
            
        case .decrementAsync(let count):
            state.isLoading = false
            state.count = count
            return .none
            
        case .error(let error):
            state.errorMessage = error
            state.isLoading = false
            state.showErrorAlert = true
            return .none
            
        case .dissmisErrorAlert:
            state.errorMessage = nil
            state.showErrorAlert = false
            print(state.errorMessage?.description ?? String())
            return .none
            
        case .timerTick:
            state.count += 1
            return .none
            
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
            
        case .setLogOut:
            state.isLogOut = true
            state.showLogOutView = false
            state.count = 0
            return .none
            
        case .setShowLogOutView(let show):
            state.showLogOutView = show
            return .none
        }
    }
    
    enum CancelId {
        case timer
    }
}
