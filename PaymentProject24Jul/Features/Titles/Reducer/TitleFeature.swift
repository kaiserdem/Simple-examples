
import SwiftUI
import ComposableArchitecture

@Reducer
struct TitleFeature {
    
    @ObservableState
    struct State: Equatable {
        var titles: [TitleData] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case downloadData
        case downloadCompletion(TitleData)
        case downloadError(Error)
    }
    
    @Dependency(\.titleEffect) var titleEffect
    
    let ids: [String] = (1...50).map { String($0)}
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .downloadData:
            state.isLoading = true
            return .merge(
                
                .run(operation: { send in
                    for id in ids {
                        do  {
                            let title = try await titleEffect.downloadTitles(id: id)
                            await send(.downloadCompletion(title))
                            
                        } catch {
                            await send(.downloadError(error))
                        }
                    }
                })
            )
            
        case .downloadCompletion(let data):
            state.titles.append(data)
            state.isLoading = false
            return .none
            
        case .downloadError(let error):
            print("Error: \(error.localizedDescription)")
            return .none
        }
    }
    

}
