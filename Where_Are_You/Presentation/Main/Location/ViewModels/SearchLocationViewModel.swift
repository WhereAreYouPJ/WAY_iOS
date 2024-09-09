//
//  KakaoLocalResponse.swift
//  Where_Are_You
//
//  Created by juhee on 07.09.24.
//

import Foundation
import Combine

class SearchLocationViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Location] = []
    @Published var recentSearches: [Location] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadRecentSearches()
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.searchPlaces(query: text)
                } else {
                    self?.searchResults = []
                }
            }
            .store(in: &cancellables)
    }
    
    func searchPlaces(query: String) {
        isLoading = true
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(encodedQuery)") else {
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(Config.kakaoRestAPIKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: KakaoLocalResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                self?.searchResults = response.documents.map { $0.toLocation() }
            }
            .store(in: &cancellables)
    }
    
    func addToRecentSearches(_ location: Location) {
        if !recentSearches.contains(where: { $0.streetName == location.streetName && $0.location == location.location }) {
            recentSearches.insert(location, at: 0)
            if recentSearches.count > 20 {
                recentSearches.removeLast()
            }
            saveRecentSearches()
        }
    }
    
    private func loadRecentSearches() {
        if let data = UserDefaults.standard.data(forKey: "RecentSearches"),
           let savedSearches = try? JSONDecoder().decode([Location].self, from: data) {
            recentSearches = savedSearches
        }
    }
    
    private func saveRecentSearches() {
        if let encoded = try? JSONEncoder().encode(recentSearches) {
            UserDefaults.standard.set(encoded, forKey: "RecentSearches")
        }
    }
    
    func deleteRecentSearch(location: Location) {
        recentSearches.removeLast()
        saveRecentSearches()
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
        saveRecentSearches()
    }
}
