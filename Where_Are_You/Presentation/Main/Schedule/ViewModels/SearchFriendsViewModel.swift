//
//  FriendsViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 27.08.24.
//

import Foundation
import SwiftUI

class SearchFriendsViewModel: ObservableObject {
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
            Friend(profileImage: "exampleProfileImage", name: "김친구"),
            Friend(profileImage: "exampleProfileImage", name: "이친구")
        ]
        friends = [
            Friend(profileImage: "exampleProfileImage", name: "박친구"),
            Friend(profileImage: "exampleProfileImage", name: "최친구"),
            Friend(profileImage: "exampleProfileImage", name: "정친구"),
            Friend(profileImage: "exampleProfileImage", name: "김친구")
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

    func confirmSelection() {
        // TODO: Implement the action for confirming the selection
        print("Selected favorites: \(selectedFavorites)")
        print("Selected friends: \(selectedFriends)")
    }

    // TODO: Implement sorting functionality for friends list
}
