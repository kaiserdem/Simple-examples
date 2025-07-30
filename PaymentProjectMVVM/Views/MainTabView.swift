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
                .tabItem {
                    Text("Images")
                }.tag(MainTab.images)
            
            TitlesListView()
                .tabItem {
                    Text("Titles")
                }.tag(MainTab.titles)
        }
    }
}

