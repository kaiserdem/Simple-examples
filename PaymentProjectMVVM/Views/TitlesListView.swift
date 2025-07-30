//
//  TitlesListView.swift
//  PaymentProjectMVVM
//
//  Created by Yaroslav Golinskiy on 29/07/2025.
//

import SwiftUI

struct TitlesListView: View {
    
    @StateObject var viewModel = TitlesViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.titles.indices, id: \.self) { titles in
                    let text = viewModel.titles[titles]
                    HStack {
                        Text(text.title)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            //viewModel.downloadAllTitles()
            Task {
               viewModel.downloadAllTitlesAsync()
            }
        }
        .padding()
    }
}
