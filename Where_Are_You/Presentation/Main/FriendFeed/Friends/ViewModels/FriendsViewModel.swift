//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import Foundation
import Moya

class FriendsViewModel: ObservableObject { // 친구 목록을 나중에는 iOS 자체 DB에 저장해뒀다가 새로고침 or 특정 시각에 업데이트
    @Published var user = User(userName: nil, profileImage: nil, memberSeq: UserDefaultsManager.shared.getMemberSeq())
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
    
//    private func setupInitialData() {
//        favorites = [
//            Friend(memberSeq: 2, profileImage: "exampleProfileImage", name: "조승연", isFavorite: false),
//            Friend(memberSeq: 3, profileImage: "exampleProfileImage", name: "김민정", isFavorite: false)
//        ]
//        friends = [
//            Friend(memberSeq: 4, profileImage: "exampleProfileImage", name: "임창균", isFavorite: true),
//            Friend(memberSeq: 5, profileImage: "exampleProfileImage", name: "이승협", isFavorite: true),
//            Friend(memberSeq: 6, profileImage: "exampleProfileImage", name: "김민지", isFavorite: true),
//            Friend(memberSeq: 7, profileImage: "exampleProfileImage", name: "조유리", isFavorite: true),
//            Friend(memberSeq: 4, profileImage: "exampleProfileImage", name: "김민규", isFavorite: true),
//            Friend(memberSeq: 5, profileImage: "exampleProfileImage", name: "최유리", isFavorite: true),
//            Friend(memberSeq: 6, profileImage: "exampleProfileImage", name: "이채영", isFavorite: true),
//            Friend(memberSeq: 7, profileImage: "exampleProfileImage", name: "최수빈", isFavorite: true)
//        ]
//    }
    
    func getUserDetail() {
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
            profileImage: response.profileImage ?? "defaultImage",
            name: response.userName,
            isFavorite: response.favorites
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
