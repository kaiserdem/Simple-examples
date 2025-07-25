
import SwiftUI
import ComposableArchitecture


@Reducer
struct ImageFeature {
    
    @ObservableState
    struct State: Equatable {
        var images: [ImageItem] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case downloadImage
        case downloadCompletion(UIImage)
        case downloadGroupImages
        case downloadGroupCompletion([UIImage])

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
            
        case .downloadGroupImages:
            state.isLoading = true
            return .run { send in
                do {
                    let images = try await imageEffect.downloadImages(ImagesContainer.imageData)
                    await send(.downloadGroupCompletion(images))
                } catch {
                    await send(.downloadError(error))
                }
                
            }
     
        case .downloadCompletion(let image):
            state.images.append(ImageItem(image: image))
            return .none
            
        case .downloadGroupCompletion(let images):
            state.isLoading = false
            state.images = images.map { ImageItem(image: $0)}
            return .none
            
        case .downloadError(let error):
            print(error.localizedDescription)
            return .none
        }
    }
}
