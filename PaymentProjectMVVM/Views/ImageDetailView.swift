//
//  ImageDetailView.swift
//  PaymentProjectMVVM
//
//  Created by Yaroslav Golinskiy on 30/07/2025.
//

import SwiftUI

struct ImageDetailView: View {
    
    let image: Image
    
    var body: some View {
        ScrollView {
            image
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

