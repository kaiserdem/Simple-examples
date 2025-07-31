//
//  TabView.swift
//  TestProjectTCA
//
//  Created by Yaroslav Golinskiy on 31/07/2025.
//

import SwiftUI
import ComposableArchitecture

enum Tab {
    case counter, image
}

struct TabView: View {
    let store: StoreOf<TabFeature>
    
    var body: some View {
        SwiftUI.TabView(selection: .init(get: { store.selectedTab } ,
                                         set: { store.send(.setSelectedTab($0))} )) {
            CounterView(store: store.scope(state: \.counterState,
                                           action: \.counterAction))
            .tabItem {
                Text("Counter")
            }.tag(Tab.counter)
            
            ImageView(store: store.scope(state: \.imageState,
                                           action: \.imageAction))
            .tabItem {
                Text("Image")
            }.tag(Tab.image)
        }
    }
}

@Reducer
struct TabFeature {
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .counter
        var counterState: CounterFeature.State = .init()
        var imageState: ImageFeature.State = .init()
    }
    
    enum Action {
        case setSelectedTab(Tab)
        case counterAction(CounterFeature.Action)
        case imageAction(ImageFeature.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .setSelectedTab(let tab):
            
            state.selectedTab = tab
            return .none
            
        case .counterAction(let action):
            let feature = CounterFeature().reduce(into: &state.counterState, action: action)
            return feature.map { .counterAction($0)}
            
        case .imageAction(let action):
            let feature = ImageFeature().reduce(into: &state.imageState, action: action)
            return feature.map { .imageAction($0)}
        
        }
    }
}


