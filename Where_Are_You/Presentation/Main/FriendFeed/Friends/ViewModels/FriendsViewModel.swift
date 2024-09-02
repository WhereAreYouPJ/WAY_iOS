//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import Foundation

class FriendsViewModel: ObservableObject {
    @Published var favorites: [Friend] = []
    @Published var friends: [Friend] = []
    @Published var searchText: String = ""
    
    init() {
        setupInitialData()
    }
    
    private func setupInitialData() {
        favorites = [
            Friend(memberSeq: 2, profileImage: "exampleProfileImage", name: "김친구"),
            Friend(memberSeq: 3, profileImage: "exampleProfileImage", name: "이친구")
        ]
        friends = [
            Friend(memberSeq: 4, profileImage: "exampleProfileImage", name: "박친구"),
            Friend(memberSeq: 5, profileImage: "exampleProfileImage", name: "최친구"),
            Friend(memberSeq: 6, profileImage: "exampleProfileImage", name: "정친구"),
            Friend(memberSeq: 7, profileImage: "exampleProfileImage", name: "김친구")
        ]
    }
    
    var filteredFavorites: [Friend] {
        if searchText.isEmpty {
            return favorites
        } else {
            return favorites.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    func clearSearch() {
        searchText = ""
    }
}
