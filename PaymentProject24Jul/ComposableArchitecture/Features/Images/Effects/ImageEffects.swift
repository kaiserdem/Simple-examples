
import SwiftUI
import Foundation
import ComposableArchitecture

protocol ImageApi {
    func downloadImage(_ withUrl: URL) async throws -> UIImage
    func downloadImages(_ withUrls: [URL]) async throws -> [UIImage]
}


struct ImageEffects: ImageApi {
    func downloadImage(_ withUrl: URL) async throws -> UIImage {
        
        do  {
            let (data, _) = try await URLSession.shared.data(from: withUrl)
            
            guard let image = UIImage(data: data)  else {
                throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error downloading with url: \(withUrl)"])
            }
            return image
        } catch {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error downloading request with url: \(withUrl)"])
        }
    }
    
    func downloadImages(_ withUrls: [URL]) async throws -> [UIImage] {
        do {
            return try await withThrowingTaskGroup(of: UIImage.self) { group in
                
                var images:[UIImage] = []
                
                for url in withUrls {
                    group.addTask {
                       try await downloadImage(url)
                    }
                }
                
                for try await image in group {
                    images.append(image)
                }
                return images
            }
        } catch {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error downloading images"])
        }
    }
}

enum ImageEffectsKey: DependencyKey {
    static let liveValue: ImageApi = ImageEffects()
}

extension DependencyValues {
    var imageEffect: ImageApi {
        get { self[ImageEffectsKey.self] }
        set { self[ImageEffectsKey.self] = newValue }

    }
}
