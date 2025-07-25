//
//  ImagesContainer.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import Foundation


struct ImagesContainer {
    static let imageData: [URL] = [
        "https://images.pexels.com/photos/16520606/pexels-photo-16520606.jpeg",
        "https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg",
        "https://images.pexels.com/photos/757889/pexels-photo-757889.jpeg"
    ].compactMap { URL(string: $0)}
}
