
import SwiftUI

struct ImagesListView: View {
    
    @StateObject var viewModel = ImageViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 90), spacing: 20)]) {
                ForEach(viewModel.images.indices)  { index in
                    Image(uiImage: viewModel.images[index])
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }
}
