
import Dependencies
import Foundation
import SwiftUI

protocol ImageApiCompletion {
    func downloadImage(url: URL, completion: @escaping(Result<UIImage, Error>) -> Void)
    func downloadImages(urls: [URL], completion: @escaping(Result<[UIImage], Error>) -> Void)
}


struct ImageManager: ImageApiCompletion {
    func downloadImage(url: URL, completion: @escaping(Result<UIImage, Error>) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failure decoding data"])))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
    
    
    func downloadImages(urls: [URL], completion: @escaping(Result<[UIImage], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var images: [UIImage] = []
        
        for url in urls {
            
            dispatchGroup.enter()
            
            downloadImage(url: url) { result in
                dispatchGroup.leave()
                if case.success(let image) = result {
                    images.append(image)
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(.success(images))
            }
        }
    }

    
}


enum ImageApiCompletionKey: DependencyKey {
    static let liveValue: ImageApiCompletion = ImageManager()
}

extension DependencyValues {
    var imageManager: ImageApiCompletion {
        get  { self[ImageApiCompletionKey.self] }
        set  { self[ImageApiCompletionKey.self] = newValue }
    }
}
