//
//  TestProjectTCATests.swift
//  TestProjectTCATests
//
//  Created by Yaroslav Golinskiy on 31/07/2025.
//

import XCTest
import ComposableArchitecture

@testable import TestProjectTCA

final class TestProjectTCATests: XCTestCase {

    @MainActor
    func testCounterFeature() async {
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        store.exhaustivity = .off
        
        await store.send(.increment) {
            $0.count = 1
        }
        
        await store.send(.decrement) {
            $0.count = 0
        }
        
        await store.send(.timerTick) {
            $0.count = 1
        }
        
        await store.send(.timerToggle) {
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(.timerTick) {
            $0.isTimerRunning = true
            $0.count = 2
        }
    }
    
    func testImageFeature() async {
        
    }
}

