//
//  KakaoLocalResponse.swift
//  Where_Are_You
//
//  Created by juhee on 07.09.24.
//

import Foundation
import Combine

class SearchPlaceViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Location] = []
    @Published var recentSearches: [Location] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadRecentSearches()
//      recentSearches = [
//        .init(from: Document(addressName: "서울대입구", roadAddressName: "서울 종로구 세종대로 171", x: "37.4808", y: "126.9526")),
//        .init(from: Document(addressName: "여의도공원", roadAddressName: "서울 영등포구 여의공원로 68", x: "37.5268", y: "126.9244")),
//        .init(from: Document(addressName: "올림픽체조경기장", roadAddressName: "서울 종로구 세종대로 173", x: "37.5221", y: "127.1259")),
//        .init(from: Document(addressName: "재즈바", roadAddressName: "서울 종로구 세종대로 174", x: "37.5665", y: "126.9780")),
//        .init(from: Document(addressName: "신도림", roadAddressName: "서울 종로구 세종대로 175", x: "37.5088", y: "126.8912")),
//        .init(from: Document(addressName: "망원한강공원", roadAddressName: "서울 종로구 세종대로 176", x: "37.5545", y: "126.8964")),
//        .init(from: Document(addressName: "부천시청", roadAddressName: "서울 종로구 세종대로 177", x: "37.5037", y: "126.7661"))
//      ]
        
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
        if !recentSearches.contains(where: { $0.id == location.id }) {
            recentSearches.insert(location, at: 0)
            if recentSearches.count > 5 {
                recentSearches.removeLast()
            }
            saveRecentSearches()
        }
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
        saveRecentSearches()
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
}
