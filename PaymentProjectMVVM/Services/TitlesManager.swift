//
//  TitlesManager.swift
//  PaymentProjectMVVM
//
//  Created by Yaroslav Golinskiy on 29/07/2025.
//
import Foundation
import Dependencies

protocol TitlesApi {
    func downloadTitle(url: URL, completion: @escaping(Result<TitleData, Error>) -> Void)
    func downloadTitles(urls: [URL], completion: @escaping(Result<[TitleData], Error>) -> Void)
    func downloadTitle(url: URL) async throws -> TitleData
    func downloadTitles(urls: [URL]) async throws -> [TitleData]

}

enum TitlesApiKey: DependencyKey {
    static let liveValue: TitlesApi = TitlesManager()
}

extension DependencyValues {
    var titlesManager: TitlesApi {
        get { self[TitlesApiKey.self] }
        set { self[TitlesApiKey.self] = newValue }
    }
}

struct TitlesManager: TitlesApi {
    
    func downloadTitle(url: URL, completion: @escaping (Result<TitleData, Error>) -> Void) {
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in // BACKGROUND thread
            
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed data"])))
                return
            }
            
            do {
                let titleData = try JSONDecoder().decode(TitleData.self, from: data)
                completion(.success(titleData))
            } catch {
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed parsing data"])))
            }
        }
        task.resume()
    }
    
    func downloadTitles(urls: [URL], completion: @escaping(Result<[TitleData], Error>) -> Void) {
        let dispachGroup = DispatchGroup()
        var titles: [TitleData] = []
        let serialQuoue = DispatchQueue(label: "serial")
        
        for url in urls {
            
            dispachGroup.enter()
            downloadTitle(url: url) { result in
                if case .success(let success) = result {
                    serialQuoue.async {
                        titles.append(success)
                    }
                }
                dispachGroup.leave()
            }
        }
        
        dispachGroup.notify(queue: .main) {
            completion(.success(titles))
        }
    }
    
    
    func downloadTitle(url: URL) async throws -> TitleData {
        do {
           let  (data, _) = try await URLSession.shared.data(from: url)
        let titleData = try JSONDecoder().decode(TitleData.self, from: data)
            return titleData
            
        } catch {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Request failer"])
        }
    }

    
    func downloadTitles(urls: [URL]) async throws -> [TitleData] {
      try await withThrowingTaskGroup(of: TitleData.self) { group in
            
            for url in urls {
                group.addTask {
                   try await downloadTitle(url: url)
                }
            }
            
             var titles: [TitleData] = []
            
            for try await title in group {
                titles.append(title)
            }
          
          return titles
        }
    }
}
