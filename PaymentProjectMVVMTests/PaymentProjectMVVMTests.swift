
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
        let testURL = URL(string: "https://picsum.photos/200/300")!
        
        imageManager.downloadImage(url: testURL) { result in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
