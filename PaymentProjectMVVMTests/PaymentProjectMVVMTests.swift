
import XCTest
@testable import PaymentProjectMVVM

final class ImageManagerTests: XCTestCase {
    var imageManager: ImageManager!
    
    override func setUp() {
        super.setUp()
        imageManager = ImageManager()
    }
    
    override func tearDown() {
        imageManager = nil
        super.tearDown()
    }
    
    func testDownloadImageSuccess() {
        let expectation = XCTestExpectation(description: "Image download success")
        
        // Використовуємо більш надійний URL
        let testURL = URL(string: "https://images.pexels.com/photos/32042925/pexels-photo-32042925.jpeg")!
        
        imageManager.downloadImage(url: testURL) { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 15.0) // Збільшуємо timeout
    }
    
    func testDownloadImageFailure() {
        let expectation = XCTestExpectation(description: "Image download failure")
        
        // Використовуємо невалідний URL
        let invalidURL = URL(string: "https://invalid-url-that-does-not-exist.com/image.jpg")!
        
        imageManager.downloadImage(url: invalidURL) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}


