//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import Foundation
import Moya

class FriendsViewModel: ObservableObject { // 친구 목록을 나중에는 iOS 자체 DB에 저장해뒀다가 새로고침 or 특정 시각에 업데이트
    @Published var user = User(
        userName: UserDefaultsManager.shared.getUserName(),
        profileImage: UserDefaultsManager.shared.getProfileImage()
    )
    @Published var favorites: [Friend] = []
    @Published var friends: [Friend] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    
    private let getFriendUseCase: GetFriendUseCase
    private let memberDetailsUseCase: MemberDetailsUseCase
    
    init(getFriendUseCase: GetFriendUseCase, memberDetailsUseCase: MemberDetailsUseCase) {
        self.getFriendUseCase = getFriendUseCase
        self.memberDetailsUseCase = memberDetailsUseCase
    }
    
    func getUserDetail() {
        if self.user.userName == nil {
            memberDetailsUseCase.execute { result in
                switch result {
                case .success(let member):
                    self.user.userName = member.userName
                    self.user.profileImage = member.profileImage
                case .failure(let error):
                    print("Error getting user: \(error.localizedDescription)")
                    self.hasError = true
                }
            }
        }
    }
    
    func getFriendsList() {
        isLoading = true
        hasError = false
        
        getFriendUseCase.execute { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let friendLists):
                    self.favorites = friendLists.favorites.compactMap { self.convertToFriend($0) }
                    self.friends = friendLists.friends.compactMap { self.convertToFriend($0) }
                case .failure(let error):
                    print("Error fetching friends: \(error.localizedDescription)")
                    self.hasError = true
                }
            }
        }
    }
    
    private func convertToFriend(_ response: GetFriendResponse) -> Friend {
        Friend(
            memberSeq: response.memberSeq,
            profileImage: response.profileImage ?? "",
            name: response.userName,
            isFavorite: response.favorites, memberCode: ""
        )
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

// FriendsViewModel 클래스에 아래 메서드 추가
extension FriendsViewModel {
    // 더미 데이터 설정 메서드
    func setDummyData() {
        // 즐겨찾기 친구들
        self.favorites = [
            Friend(
                memberSeq: 101,
                profileImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3",
                name: "루시",
                isFavorite: true,
                memberCode: "JIMIN12345"
            ),
            Friend(
                memberSeq: 102,
                profileImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3",
                name: "한아름",
                isFavorite: true,
                memberCode: "SJPARK9876"
            )
        ]
        
        // 일반 친구들
        self.friends = [
            Friend(
                memberSeq: 201,
                profileImage: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3",
                name: "제이미",
                isFavorite: false,
                memberCode: "SKYLEE7777"
            ),
            Friend(
                memberSeq: 202,
                profileImage: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3",
                name: "한아름송이",
                isFavorite: false,
                memberCode: "SOMIJ1234"
            ),
            Friend(
                memberSeq: 203,
                profileImage: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3",
                name: "강",
                isFavorite: false,
                memberCode: "MSHAN5678"
            ),
            Friend(
                memberSeq: 204,
                profileImage: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3",
                name: "민지",
                isFavorite: false,
                memberCode: "JWYOON8989"
            )
        ]
    }
}
