//
//  ImageListView.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct ImageListView: View {
    let store: StoreOf<ImageFeature>
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60, maximum: 90))],spacing: 20) {
                ForEach(store.images) {
                    let image = Image(uiImage: $0.image)
                    image
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .onAppear {
            store.send(.downloadImage)
        }
    }
}
