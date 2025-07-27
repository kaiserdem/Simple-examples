
import SwiftUI
import ComposableArchitecture

struct TitlesListView: View {
    let store: StoreOf<TitleFeature>
    
    var body: some View {
        VStack {
            if store.isLoading {
                ProgressView()
            }
            ScrollView {
                ForEach(store.titles) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                    }
                    .padding()
                }
                
            }.onAppear {
                store.send(.downloadData)
            }
        }
    }
}
