//
//  FriendsViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 27.08.24.
//

import Foundation
import SwiftUI
import Combine

class SearchFriendsViewModel: ObservableObject {
    @Published var selectedFavorites: Set<UUID> = []
    @Published var selectedFriends: Set<UUID> = []
    var cancellables = Set<AnyCancellable>()
    
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
        // 이미 선택되어 있는지 확인
        if isSelected(friend: friend) {
            removeFromSelection(friend: friend)
        } else {
            // 친구 타입에 따라 적절한 컬렉션에 추가
            if favorites.contains(where: { $0.memberSeq == friend.memberSeq }) {
                if let favoriteToAdd = favorites.first(where: { $0.memberSeq == friend.memberSeq }) {
                    selectedFavorites.insert(favoriteToAdd.id)
                }
            } else {
                if let friendToAdd = friends.first(where: { $0.memberSeq == friend.memberSeq }) {
                    selectedFriends.insert(friendToAdd.id)
                }
            }
        }
    }
    
    func isSelected(friend: Friend) -> Bool {
        let isFavoriteSelected = favorites.contains { favorite in
            favorite.memberSeq == friend.memberSeq && selectedFavorites.contains(favorite.id)
        }
        
        let isFriendSelected = friends.contains { friendItem in
            friendItem.memberSeq == friend.memberSeq && selectedFriends.contains(friendItem.id)
        }
        
        return isFavoriteSelected || isFriendSelected
    }
    
    func removeFromSelection(friend: Friend) {
        // 즐겨찾기에서 제거 시도
        if let favoriteToRemove = favorites.first(where: { $0.memberSeq == friend.memberSeq }) {
            selectedFavorites.remove(favoriteToRemove.id)
        }
        
        // 일반 친구 목록에서 제거 시도
        if let friendToRemove = friends.first(where: { $0.memberSeq == friend.memberSeq }) {
            selectedFriends.remove(friendToRemove.id)
        }
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
