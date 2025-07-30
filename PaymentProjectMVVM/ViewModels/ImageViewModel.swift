
import SwiftUI
import Dependencies
import Combine

class ImageViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    private var cancellables = Set<AnyCancellable>()

    
    @Dependency(\.imageManager) var imageManager
    @Dependency(\.imageProManager) var imageProManager

    
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
    func downloadImagesPRO() {
        imageProManager.downloadImages(urls: ImagesContainer.imageData) {[weak self] result in
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
    
    func downloadImagesWithPublishers(urls: [URL]) {
            let publishers = urls.map { url in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .compactMap { UIImage(data: $0) }
                    .replaceError(with: nil)
                    .compactMap { $0 }
            }
            
            Publishers.MergeMany(publishers)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] image in
                    self?.images.append(image)
                }
                .store(in: &cancellables)
        }
}
