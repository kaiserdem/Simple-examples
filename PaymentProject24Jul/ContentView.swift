//
//  ContentView.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 24/07/2025.
//

import SwiftUI
import ComposableArchitecture


struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            
            if store.isLoading {
                ProgressView()
            } else {
                Text(store.count.description)
                    .font(.title)
            }
            
            HStack {
                Button("+") {
                    store.send(.increment)
                }
                .padding()
                .border(.gray)
                
                
                Button("-") {
                    store.send(.decrement)
                }
                .padding()
                .border(.gray)
            }
            
            Button(store.isTimerRunning ? "Stop": "Start") {
                store.send(.timerToggle)
            }
            .padding()
            .border(store.isTimerRunning ? .red : .green)
        }
        .padding()
    }
}

@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        var count: Int = 0
        var isLoading: Bool = false
        var isTimerRunning: Bool = false
    }
    
    enum Action {
        case increment
        case incrementAsync(Int)
        case decrement
        case decrementAsync(Int)
        case timerTick
        case timerToggle
        case error(String)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.counterEffect) var effectAsync
    
    func reduce(into state: inout State, action: Action) async -> Effect<Action> {
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
            return .none
            
        case .increment:
            let count = state.count
            state.isLoading = true
            return .run { send in
                do  {
                    let effect = try await effectAsync.incrementAsync(count)
                    await send(.incrementAsync(effect))
                    
                } catch {
                    await send(.error(error.localizedDescription))
                }
            }
            
        case .decrement:
            state.isLoading = true
            let count = state.count
            
            return .run { send in
                do {
                    
                    let effect = try await effectAsync.decrementAsync(count)
                    await send(.decrementAsync(effect))
                } catch {
                    await send(.error(error.localizedDescription))
                }
            }
            
            
        case .decrementAsync(let count):
            state.count = count
            state.isLoading = false
            return .none
            
        case .timerTick:
            state.count += 1
            return .none
            
            
        case .error(let error):
            state.isLoading = false
            print("Error: \(error)")
            return .none
        }
    }
}


enum CancelId {
    case timer
}

protocol CounterApi {
    func incrementAsync(_ currentCount: Int) async throws -> Int
    func decrementAsync(_ currentCount: Int) async throws -> Int
}

struct CounterEffect: CounterApi {
    
    let errorProbiably: Double = 0.25
    
    func incrementAsync(_ currentCount: Int) async throws -> Int {
       
        try await Task.sleep(for: .seconds(1))
        
        if Double.random(in: 0...1) < errorProbiably {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error increment Async"])
        }
        
        return currentCount + 1
    }
    
    func decrementAsync(_ currentCount: Int) async throws -> Int {
        
        try await Task.sleep(for: .seconds(1))
        
        if Double.random(in: 0...1) < errorProbiably {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error decrementAsync"])
        }
        
        return currentCount - 1
    }
    
}


enum CounterEffectKey: DependencyKey {
    static let liveValue: CounterApi = CounterEffect()
}


extension DependencyValues {
    var counterEffect: CounterApi {
        get { self[CounterEffectKey.self] }
        set { self[CounterEffectKey.self] = newValue }
    }
}
