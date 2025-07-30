//
//  MainTabViewModel.swift
//  PaymentProjectMVVM
//
//  Created by Yaroslav Golinskiy on 29/07/2025.
//

import SwiftUI

class MainTabViewModel: ObservableObject {
    @Published var selectedTab: MainTab = .images
    @Published var imagesPath: [ImagesRoute] = []
    @Published var titlesPath: [TitlesRoute] = []
    
    
    func switchToTab(_ tab: MainTab) {
        selectedTab = tab
    }
}
enum ImagesRoute: Hashable {
    case imagesList
    case imageDetail(index: Int)
}


enum TitlesRoute: Hashable {
    case titlesList
    case titlesDetail
}

enum MainTab: Int, CaseIterable {
    case images = 0
    case titles
}
