
import SwiftUI
import ComposableArchitecture

struct TabView: View {
    let store: StoreOf<TabFeature>
    
    var body: some View {
        SwiftUI.TabView(selection: .init(
            get: {store.selectedTab},
            set: {store.send(.setSelectedTab($0))})) {
                
                CounterView(store: store.scope(state: \.counterState,
                                               action: \.counterAction))
                .tabItem {
                    Text("Counter")
                }
                .tag(Tab.counter)
                
                ImageListView(store: store.scope(state: \.imagesState,
                                               action: \.imagesAction))
                .tabItem {
                    Text("Images")
                }
                .tag(Tab.images)
                
                TitlesListView(store: store.scope(state: \.titlesState,
                                               action: \.titlesAction))
                .tabItem {
                    Text("Titles")
                }
                .tag(Tab.titles)
        }
        
    }
}
