//
//  MainTabView.swift
//  PaymentProjectMVVM
//
//  Created by Yaroslav Golinskiy on 29/07/2025.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var viewModel = MainTabViewModel()
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ImagesListView()
                .environmentObject(viewModel)

                .tabItem {
                    Text("Images")
                }.tag(MainTab.images)
            
            TitlesListView()
                .environmentObject(viewModel)
                .tabItem {
                    Text("Titles")
                }.tag(MainTab.titles)
            
        }
    }
}

