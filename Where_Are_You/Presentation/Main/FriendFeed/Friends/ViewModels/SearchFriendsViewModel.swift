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
    
    // 검색어 처리
    @Published var inputSearchText: String = "" // 사용자 입력 값
    @Published private var debouncedSearchText: String = "" // 디바운스된 값
    private var searchTextCancellable: AnyCancellable?
    
    init(
        friendsViewModel: FriendsViewModel,
        getFriendUseCase: GetFriendUseCase
    ) {
        self.friendsViewModel = friendsViewModel
        self.getFriendUseCase = getFriendUseCase
        
        // 디바운스 설정
        searchTextCancellable = $inputSearchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.debouncedSearchText = value
                self?.friendsViewModel.searchText = value // 디바운스된 값을 필터링에 사용
            }
    }
    
//    // FriendsViewModel에서 forward
//    var searchText: String {
//        get { friendsViewModel.searchText }
//        set { friendsViewModel.searchText = newValue }
//    }
    var searchText: String {
        get { inputSearchText }
        set { inputSearchText = newValue }
    }
    
    // 강조 표시에 사용할 디바운스된 검색어
    var highlightText: String {
        return debouncedSearchText
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
        // 사용자 입력 텍스트 초기화
        inputSearchText = ""
        
        // 디바운스 타이머를 기다리지 않고 즉시 디바운스된 검색어도 초기화
        debouncedSearchText = ""
        
        // FriendsViewModel의 검색어도 초기화
        friendsViewModel.searchText = ""
        
        // 현재 실행 중인 디바운스 작업 취소
        searchTextCancellable?.cancel()
        searchTextCancellable = $inputSearchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.debouncedSearchText = value
                self?.friendsViewModel.searchText = value
            }
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

// SearchFriendsViewModel 확장 - 더미 데이터 추가
extension SearchFriendsViewModel {
    // 더미 데이터 설정 메서드
    func setDummyData() {
        // FriendsViewModel에 더미 데이터 설정
        self.friendsViewModel.setDummyData()
        
        // 기본적으로 첫 번째 친구를 선택 상태로 설정 (데모용)
        if let firstFavorite = self.friendsViewModel.favorites.first {
            self.selectedFavorites.insert(firstFavorite.id)
        }
        
        if let firstFriend = self.friendsViewModel.friends.first {
            self.selectedFriends.insert(firstFriend.id)
        }
    }
}
