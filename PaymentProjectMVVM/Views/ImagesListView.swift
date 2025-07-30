
import SwiftUI

struct ImagesListView: View {
    
    @StateObject var viewModel = ImageViewModel()
    @EnvironmentObject var mainTabViewModel: MainTabViewModel

    
    var body: some View {
        NavigationStack(path: $mainTabViewModel.imagesPath) {
            ScrollView {
                if viewModel.images.isEmpty {
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Button("Download Group") {
                                viewModel.downloadGroup()
                            }
                            .border(.gray)
                            
                            Button("Download linearly") {
                                viewModel.downloadLinearly()
                            }
                            .border(.gray)
                            
                            Button("Download Group by 3 items") {
                                viewModel.downloadImagesPRO()
                            }
                            .border(.gray)
                        }
                        
                        Spacer()
                    }
                    
                } else {
                    Button("Remove all images") {
                        viewModel.images = []
                    }
                    .border(.red)
                    
                }
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 90), spacing: 20)]) {
                    ForEach(viewModel.images.indices, id: \.self) { index in
                        let image = viewModel.images[index]
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                mainTabViewModel.imagesPath.append(.imageDetail(index: index))
                            }
                    }
                }
            }
            .padding()
            .navigationDestination(for: ImagesRoute.self) { route in
                switch route {
                case .imagesList:
                    ImagesListView()
                case .imageDetail(let index):
                    ImageDetailView(image: Image(uiImage: viewModel.images[index]))
                }
            }
        }
    }
}

