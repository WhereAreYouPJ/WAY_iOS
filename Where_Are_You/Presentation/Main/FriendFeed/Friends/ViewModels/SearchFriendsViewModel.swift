//
//  FriendsViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 27.08.24.
//

import Foundation
import SwiftUI

class SearchFriendsViewModel: ObservableObject {
    @Published var selectedFavorites: Set<UUID> = []
    @Published var selectedFriends: Set<UUID> = []
    
    let friendsViewModel: FriendsViewModel
    private let getFriendUseCase: GetFriendUseCase
    
    init(
        friendsViewModel: FriendsViewModel,
        getFriendUseCase: GetFriendUseCase
    ) {
        self.friendsViewModel = friendsViewModel
        self.getFriendUseCase = getFriendUseCase
    }
    
    // FriendsViewModel에서 forward
    var searchText: String {
        get { friendsViewModel.searchText }
        set { friendsViewModel.searchText = newValue }
    }
    
    var favorites: [Friend] {
        friendsViewModel.favorites
    }
    
    var friends: [Friend] {
        friendsViewModel.friends
    }
    
    var filteredFavorites: [Friend] {
        friendsViewModel.filteredFavorites
    }
    
    var filteredFriends: [Friend] {
        friendsViewModel.filteredFriends
    }
    
    func clearSearch() {
        friendsViewModel.clearSearch()
    }
    
    // SearchFriendsViewModel 고유 기능
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
    
    func getSelectedFriends() -> [Friend] {
        return favorites.filter { selectedFavorites.contains($0.id) } +
        friends.filter { selectedFriends.contains($0.id) }
    }
    
    func confirmSelection() -> [Friend] {
        let selectedFriends = getSelectedFriends()
        print("Selected friends: \(selectedFriends.map { $0.name })")
        return selectedFriends
    }
    
    func resetSelection() {
        selectedFavorites.removeAll()
        selectedFriends.removeAll()
    }
}
