//
//  ImageEffects.swift
//  PaymentProject24Jul
//
//  Created by Yaroslav Golinskiy on 25/07/2025.
//

import SwiftUI
import Foundation
import ComposableArchitecture

protocol ImageApi {
    func downloadImage(_ withUrl: URL) async throws -> UIImage
   // func downloadImages(_ withUrls: [URL]) async throws -> [UIImage]
}


struct ImageEffects: ImageApi {
    func downloadImage(_ withUrl: URL) async throws -> UIImage {
        
        do  {
            let (data, _) = try await URLSession.shared.data(from: withUrl)
            
            guard let image = UIImage(data: data)  else {
                throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error downloading with url: \(withUrl)"])
            }
            return image
        } catch {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error downloading request with url: \(withUrl)"])
        }
                            

            
//        } catch {
//           throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Error downloading with url: \(withUrl)"])
//        }
    }
    
//    func downloadImages(_ withUrls: [URL]) async throws -> [UIImage] {
//        
//    }
}

enum ImageEffectsKey: DependencyKey {
    static let liveValue: ImageApi = ImageEffects()
}

extension DependencyValues {
    var imageEffect: ImageApi {
        get { self[ImageEffectsKey.self] }
        set { self[ImageEffectsKey.self] = newValue }

    }
}
