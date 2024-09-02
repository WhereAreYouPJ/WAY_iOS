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
    @Published var selectedFavorites: Set<UUID> = []
    @Published var selectedFriends: Set<UUID> = []
    @Published var searchText: String = ""
    
    init() {
        setupInitialData()
        setupBindings()
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
    
    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
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
    
    var selectedList: [Friend] {
        favorites.filter { selectedFavorites.contains($0.id) } +
        friends.filter { selectedFriends.contains($0.id) }
    }
    
    func toggleSelection(for friend: Friend) {
        if favorites.contains(where: { $0.id == friend.id }) {
            if selectedFavorites.contains(friend.id) {
                selectedFavorites.remove(friend.id)
            } else {
                selectedFavorites.insert(friend.id)
            }
        } else {
            if selectedFriends.contains(friend.id) {
                selectedFriends.remove(friend.id)
            } else {
                selectedFriends.insert(friend.id)
            }
        }
    }
    
    func isSelected(friend: Friend) -> Bool {
        selectedFavorites.contains(friend.id) || selectedFriends.contains(friend.id)
    }
    
    func removeFromSelection(friend: Friend) {
        selectedFavorites.remove(friend.id)
        selectedFriends.remove(friend.id)
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func getSelectedFriends() -> [Friend] {
        return favorites.filter { selectedFavorites.contains($0.id) } +
        friends.filter { selectedFriends.contains($0.id) }
    }
    
    func confirmSelection() -> [Friend] {
        let selectedFriends = getSelectedFriends()
        print("Selected friends: \(selectedFriends.map { $0.name })")
        return selectedFriends
    }
}
