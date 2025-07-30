
import Dependencies
import Foundation
import SwiftUI
import UIKit

protocol ImageApiCompletion {
    func downloadImage(url: URL, completion: @escaping(Result<UIImage, Error>) -> Void)
    func downloadImages(urls: [URL], completion: @escaping(Result<[UIImage], Error>) -> Void)
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

enum ImageApiCompletionProKey: DependencyKey {
    static let liveValue: ImageApiCompletionPro = ImageManagerPro()
}

extension DependencyValues {
    var imageProManager: ImageApiCompletionPro {
        get  { self[ImageApiCompletionProKey.self] }
        set  { self[ImageApiCompletionProKey.self] = newValue }
    }
}

protocol ImageApiCompletionPro {
    func downloadImage(url: URL, completion: @escaping(Result<UIImage, Error>) -> Void)
    func downloadImages(urls:[URL], completion: @escaping(Result<[UIImage], Error>) -> Void)
}


class ImageManagerPro: ImageApiCompletionPro {
    
    private var downloadedImages: [URL: UIImage] = [:]
    private let dispachQueue = DispatchQueue.init(label: "DispatchQueue", attributes: .concurrent)
    private let dispatchSemaphore = DispatchSemaphore(value: 3)
    private var dataTasks: [URL: URLSessionDataTask] = [:]
    
    func downloadImage(url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failure image"])))
                return
            }
            
            downloadedImages[url] = image
            completion(.success(image))
        }
        task.resume()
    }
    
    func downloadImages(urls:[URL], completion: @escaping(Result<[UIImage], Error>) -> Void) {
        let dispachGroup = DispatchGroup()
        var images: [UIImage] = []
        
        for url in urls {
            
            dispachGroup.enter()
            dispatchSemaphore.wait()
            
            dispachQueue.async {
                self.downloadImage(url: url) { [weak self] result in
                    
                    dispachGroup.leave()
                    self?.dispatchSemaphore.signal()
                    
                    if case .success(let success) = result {
                        images.append(success)
                    }
                }
            }
        }
        
        dispachGroup.notify(queue: .main) {
            completion(.success(images))
        }
        
       
    }
    
}
