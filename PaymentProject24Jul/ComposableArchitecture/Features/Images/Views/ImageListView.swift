
import SwiftUI
import ComposableArchitecture

struct ImageListView: View {
    let store: StoreOf<ImageFeature>
    var body: some View {
        VStack {
            HStack {
                Button("Download Image") {
                    store.send(.downloadImage)
                }
                .border(.cyan)
                
                Button("download Group Images") {
                    store.send(.downloadGroupImages)
                }
                .border(.cyan)
            }
            
            Spacer()
            
            if store.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 90))],spacing: 20) {
                        ForEach(store.images) {
                            let image = Image(uiImage: $0.image)
                            image
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }
        }
        .padding()
    }
}
