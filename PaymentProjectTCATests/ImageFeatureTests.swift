import XCTest
import ComposableArchitecture
@testable import PaymentProjectTCA

@MainActor
final class ImageFeatureTests: XCTestCase {
    
    struct MockImageApi: ImageApi {
        var shouldSucceed = true
        var mockImages = [UIImage(), UIImage()]
        
        func downloadImage(_ withUrl: URL) async throws -> UIImage {
            if shouldSucceed {
                return UIImage()
            } else {
                throw NSError(domain: "Test", code: 1, userInfo: nil)
            }
        }
        
        func downloadImages(_ withUrls: [URL]) async throws -> [UIImage] {
            if shouldSucceed {
                return mockImages
            } else {
                throw NSError(domain: "Test", code: 1, userInfo: nil)
            }
        }
    }
    
    func testDownloadGroupImagesSuccess() async {
        let store = TestStore(initialState: ImageFeature.State()) {
            ImageFeature()
        } withDependencies: {
            $0.imageEffect = MockImageApi()
        }
        
        store.exhaustivity = .off
        
        await store.send(.downloadGroupImages)
        await store.receive(\.downloadGroupCompletion)
        await store.finish()
    }
}
