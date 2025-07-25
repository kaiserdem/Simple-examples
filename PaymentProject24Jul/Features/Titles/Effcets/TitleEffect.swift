
import SwiftUI
import ComposableArchitecture

protocol TitleApi {
    func downloadTitles(id: String) async throws -> TitleData
}

struct TitleEffect: TitleApi {
    func downloadTitles(id: String) async throws -> TitleData {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(id)") else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(TitleData.self, from: data)
        } catch {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed responce data"])
        }
    }
}


enum TitleEffectKey: DependencyKey {
    static let liveValue: TitleApi = TitleEffect()
}

extension DependencyValues {
    var titleEffect: TitleApi {
        get { self[TitleEffectKey.self] }
        set { self[TitleEffectKey.self] = newValue }
    }
}
