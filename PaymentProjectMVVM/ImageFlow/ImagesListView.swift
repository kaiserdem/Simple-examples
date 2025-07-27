
import SwiftUI

struct ImagesListView: View {
    
    @StateObject var viewModel = ImageViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                Button("Download Group") {
                    viewModel.downloadGroup()
                }
                .border(.gray)
                
                Button("Download linearly") {
                    viewModel.downloadLinearly()
                }
                .border(.gray)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 90), spacing: 20)]) {
                ForEach(viewModel.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}
