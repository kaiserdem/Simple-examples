//
//  CounterEffect.swift
//  TestProjectTCA
//
//  Created by Yaroslav Golinskiy on 01/08/2025.
//

import ComposableArchitecture
import Foundation

protocol CounterApi {
    func increment(count: Int) async throws -> Int
    func decrement(count: Int) async throws -> Int
}

enum CounterApiKey: DependencyKey {
    static let liveValue: CounterApi = CounterEffect()
}

extension DependencyValues {
    var conterEffect: CounterApi {
        get { self[CounterApiKey.self] }
        set { self[CounterApiKey.self] = newValue }
    }
}

struct CounterEffect: CounterApi {
    
    let errorProbiably: Double = 0.25
    
    func increment(count: Int) async throws -> Int {
        
        try await Task.sleep(for: .seconds(1))
        
        if Double.random(in: 0...1) < errorProbiably {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error increment"])
        }
        
        return count + 1
        
    }
    
    func decrement(count: Int) async throws -> Int {
        try await Task.sleep(for: .seconds(1))
        
        if Double.random(in: 0...1) < errorProbiably {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error decrement"])
        }
        
        return count - 1
    }
    
}
