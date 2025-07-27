
import SwiftUI
import Dependencies

class ImageViewModel: ObservableObject {
     @Published var images: [UIImage] = []
    
    @Dependency(\.imageManager) var imageManager
    
    func downloadLinearly() {
        
        ImagesContainer.imageData.forEach { url in
            
            imageManager.downloadImage(url: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.images.append(image)
                    }
                case .failure(let error):
                    print("Errror: \(error.localizedDescription), withUrl: \(url.absoluteString)")
                }
            }
        }
    }
    
    func downloadGroup() {
        imageManager.downloadImages(urls: ImagesContainer.imageData) {  [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let allImages):
                DispatchQueue.main.async {
                    self.images = allImages
                }
                
            case .failure(let error):
                print("Errror: \(error.localizedDescription)")
            }
            
        }
    }
}
