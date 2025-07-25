//
//  TabFeature.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import SwiftUI
import ComposableArchitecture

enum Tab {
    case counter, images
}

@Reducer
struct TabFeature {
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .counter
        var counterState: CounterFeature.State = .init()
        var imagesState: ImageFeature.State = .init()
    }
    
    enum  Action {
        case setSelectedTab(Tab)
        case counterAction(CounterFeature.Action)
        case imagesAction(ImageFeature.Action)
    }
    
    var body: some Reducer <State, Action> {
        Reduce { state, action in
            switch action {
            case .setSelectedTab(let tab):
                state.selectedTab = tab
                return .none
                
            case .counterAction(let action):
                let counterReature = CounterFeature().reduce(into: &state.counterState, action: action)
                return counterReature.map { .counterAction($0)}
                
            case .imagesAction(let action):
                let counterReature = ImageFeature().reduce(into: &state.imagesState, action: action)
                return counterReature.map { .imagesAction($0)}
            }
        }
    }
}

