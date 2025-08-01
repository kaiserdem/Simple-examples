//
//  ImageView.swift
//  TestProjectTCA
//
//  Created by Yaroslav Golinskiy on 31/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct ImageView: View {
    
    let store: StoreOf<ImageFeature>
    var body: some View {
        VStack {
            Button("Add Image") {
                store.send(.download)
            }
            .frame(maxWidth: .infinity)
            .border(.fill)
            if store.isloading {
                ProgressView()
            }
            ScrollView {
                // LazyVGrid(columns: [GridItem(.adaptive(minimum: 70, maximum: 120),spacing: 20)]) {
                ForEach(store.images.indices, id: \.self) { index in
                    Image(uiImage: store.images[index])
                        .resizable()
                        .scaledToFit()
                }
                // }
            }
        }
        .onAppear {
            store.send(.download)
        }
        .padding()
    }
}


@Reducer
struct ImageFeature {
    
    @ObservableState
    struct State: Equatable {
        var images: [UIImage] = []
        var isloading: Bool = false
    }
    
    enum Action {
        case download
        case downloadCompletion(UIImage)
        case downloadErrror(Error)
    }
    
    @Dependency(\.imageEffect) var imageEffect
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .download:
            state.isloading = true
            guard let url = URL(string: "https://picsum.photos/200/300") else {
                return .none
            }
            
            return .run { send in
                do {
                    let effect = try await imageEffect.downloadImage(url: url)
                    await send(.downloadCompletion(effect))
                } catch {
                    await send(.downloadErrror(error))
                }
            }
            
        case .downloadCompletion(let image):
            state.images.insert(image, at: 0)
            state.isloading = false
            return .none
            
        case .downloadErrror(let error):
            state.isloading = false
            print("Error: \(error)")
            return .none
        }
    }
}


protocol ApiImage {
    func downloadImage(url: URL) async throws -> UIImage
}

enum ApiImageKey: DependencyKey {
    static let liveValue: ApiImage = ImageEffect()
}

extension DependencyValues {
    var imageEffect: ApiImage {
        get { self[ApiImageKey.self] }
        set { self[ApiImageKey.self] = newValue }
    }
}


struct ImageEffect: ApiImage {
    func downloadImage(url: URL) async throws -> UIImage {
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed data image"])
        }
        
        return image
    }
}
