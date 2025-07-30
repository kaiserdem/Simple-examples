//
//  TitlesViewModel.swift
//  PaymentProjectMVVM
//
//  Created by Yaroslav Golinskiy on 29/07/2025.
//

import Dependencies
import Foundation

class TitlesViewModel: ObservableObject {
    
    @Published var titles: [TitleData] = []
    
    @Dependency(\.titlesManager) var titlesManager
    
    var ids: [String] {
        get {
            (1...50).map { String($0)}
        }
    }
    
    func downloadTitles() {
        
        for id in ids {
            
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(id)") else {
                print("error url")
                return
            }
            
            titlesManager.downloadTitle(url: url) { [weak self] result in
                
                switch result {
                case .success(let title):
                    DispatchQueue.main.async {
                        self?.titles.append(title)
                    }
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription), withUrl: \(url)")
                }
            }
        }
    }
    
    func downloadAllTitles() {
        
        let urls: [URL] = ids.compactMap { URL(string: "https://jsonplaceholder.typicode.com/todos/\($0)")}
        
        
        titlesManager.downloadTitles(urls: urls) { [weak self] result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    self?.titles = titles
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @MainActor
    func downloadAllTitlesAsync() {
        
        let url: [URL] = ids.compactMap { URL(string: "https://jsonplaceholder.typicode.com/todos/\($0)")}
        
        Task {
            do {
                titles =  try await titlesManager.downloadTitles(urls: url)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    
}
