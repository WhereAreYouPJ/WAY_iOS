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
    @Published var selectedOrder: [Friend] = []
    
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
        inputSearchText = "" // 사용자 입력 텍스트 초기화
        debouncedSearchText = "" // 디바운스 타이머를 기다리지 않고 즉시 디바운스된 검색어도 초기화
        friendsViewModel.searchText = "" // FriendsViewModel의 검색어도 초기화
        
        // 현재 실행 중인 디바운스 작업 취소
        searchTextCancellable?.cancel()
        searchTextCancellable = $inputSearchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.debouncedSearchText = value
                self?.friendsViewModel.searchText = value
            }
    }
    
    // MARK: 친구 선택 로직

    // selectedList를 selectedOrder로 변경
    var selectedList: [Friend] {
        return selectedOrder
    }
    
    func toggleSelection(for friend: Friend) {
        if isSelected(friend: friend) {
            removeFromSelection(friend: friend)
        } else {
            // 친구가 이미 선택되어 있지 않은 경우에만 추가
            selectedOrder.append(friend)
        }
    }
    
    func isSelected(friend: Friend) -> Bool {
        return selectedOrder.contains { $0.memberSeq == friend.memberSeq }
    }
    
    func removeFromSelection(friend: Friend) {
        selectedOrder.removeAll { $0.memberSeq == friend.memberSeq }
    }
    
    func getSelectedFriends() -> [Friend] {
        return selectedOrder // 선택 순서대로 반환
    }
    
    func confirmSelection() -> [Friend] {
        let selectedFriends = getSelectedFriends()
        print("Selected friends: \(selectedFriends.map { $0.name })")
        return selectedFriends
    }
    
    func resetSelection() {
        selectedOrder.removeAll()
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
            self.selectedOrder.append(firstFavorite)
        }
        
        if let firstFriend = self.friendsViewModel.friends.first {
            self.selectedOrder.append(firstFriend)
        }
    }
}
