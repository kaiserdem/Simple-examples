//
//  ImageFeature.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import SwiftUI
import ComposableArchitecture


@Reducer
struct ImageFeature {
    
    @ObservableState
    struct State: Equatable {
        var images: [ImageItem] = []
    }
    
    enum Action {
        case downloadImage
        case downloadCompletion(UIImage)
        case downloadError(Error)
    }
    
    @Dependency(\.imageEffect) var imageEffect
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        case .downloadImage:
            return .merge(
                ImagesContainer.imageData.map { url in
                    .run { send in
                        do {
                            let image = try await imageEffect.downloadImage(url)
                            await send(.downloadCompletion(image))
                        } catch {
                            await send(.downloadError(error))
                        }
                    }
                }
            )
     
        case .downloadCompletion(let image):
            state.images.append(ImageItem(image: image))
            return .none
            
        case .downloadError(let error):
            print(error.localizedDescription)
            return .none
        }
    }
}
