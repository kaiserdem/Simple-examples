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
        VStack {
            Text("\(store.count)")
            
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
        }
        .padding()
    }
}


@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        var count: Int = 0
        var isTimerRunning: Bool = false
    }
    
    
    enum Action {
        case increment
        case decrement
        case timerTick
        case timerToggle
    }
    
    @Dependency(\.continuousClock) var clock
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .increment:
            state.count += 1
            return .none
            
        case .decrement:
            state.count -= 1
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
        }
    }
    
    enum CancelId {
        case timer
    }
}
