//
//  File.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 26/07/2025.
//

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
