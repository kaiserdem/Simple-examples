
import SwiftUI
import ComposableArchitecture

@Reducer
struct CoreFeature {
    
    @ObservableState
    struct State: Equatable {
        var isLoggedIn: Bool = true
        var loginState: LoginFeature.State = .init()
        var tabState: TabFeature.State = .init()
    }
    
    enum Action {
        case setLogin
        case loginAction(LoginFeature.Action)
        case tabAction(TabFeature.Action)
    }
    
    var body: some Reducer <State, Action> {
        Reduce { state,  action in
            switch action {
            case .setLogin:
                state.isLoggedIn = true
                return .none
                
            case .loginAction(let action):
                let feature = LoginFeature().reduce(into: &state.loginState, action: action)
                
                if case .setLogin = action {
                    state.isLoggedIn = true
                }
                
                return feature.map { .loginAction($0)}
                
            case .tabAction(let action):
                let feature = TabFeature().reduce(into: &state.tabState, action: action)
                
                if case .counterAction(.setLogout) = action {
                    state.isLoggedIn = false
                }
                
                return feature.map { .tabAction($0)}
            }
        }
    }
}
