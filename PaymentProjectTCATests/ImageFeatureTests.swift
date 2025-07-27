import XCTest
import ComposableArchitecture
@testable import PaymentProjectTCA

@MainActor
final class ImageFeatureTests: XCTestCase {
    func testImageDownloadSuccess() {
        let store = TestStore(initialState: ImageFeature.State()) {
            ImageFeature()
        }
        
        store.assert {
            $0.images = []
            $0.isLoading = false
        }
        
        store.send(.downloadImages) {
            $0.isLoading = true
        }
        
        // Симулюємо успішне завантаження
        store.receive(.imagesDownloaded(.success([testImage]))) {
            $0.images = [testImage]
            $0.isLoading = false
        }
    }
    
    func testImageDownloadFailure() {
        let store = TestStore(initialState: ImageFeature.State()) {
            ImageFeature()
        }
        
        store.send(.downloadImages) {
            $0.isLoading = true
        }
        
        // Симулюємо помилку
        store.receive(.imagesDownloaded(.failure(NetworkError.failed))) {
            $0.isLoading = false
            $0.error = "Failed to download images"
        }
    }
}
