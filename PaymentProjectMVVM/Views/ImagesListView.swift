
import SwiftUI

struct ImagesListView: View {
    
    @StateObject var viewModel = ImageViewModel()
    
    var body: some View {
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
                ForEach(viewModel.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            
                        }
                }
            }
        }
        .padding()
    }
}

