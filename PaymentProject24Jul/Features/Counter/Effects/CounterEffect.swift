
import SwiftUI
import ComposableArchitecture

enum CancelId {
    case timer
}

protocol CounterApi {
    func incrementAsync(_ step: Int, _ currentCount: Int) async throws -> Int
    func decrementAsync(_ step: Int, _ currentCount: Int) async throws -> Int
}

struct CounterEffect: CounterApi {
    
    let errorProbiably: Double = 0.25
    
    func incrementAsync(_ step: Int, _ currentCount: Int) async throws -> Int {
       
        try await Task.sleep(for: .seconds(1))
        
        if Double.random(in: 0...1) < errorProbiably {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error increment Async"])
        }
        
        return currentCount + step
    }
    
    func decrementAsync(_ step: Int, _ currentCount: Int) async throws -> Int {
        
        try await Task.sleep(for: .seconds(1))
        
        if Double.random(in: 0...1) < errorProbiably {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error decrementAsync"])
        }
        
        return currentCount - step
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
