//
//  FriendDetailViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 19.11.24.
//

import Foundation

class FriendDetailViewModel: ObservableObject {
    @Published var friend: Friend?
    @Published var isMyProfile: Bool
    @Published var showError: Bool = false
    
    private let deleteFriendUseCase: DeleteFriendUseCase
    private let deleteFavoriteFriendUseCase: DeleteFavoriteFriendUseCase
    private let postFavoriteFriendUseCase: PostFavoriteFriendUseCase
    private let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    init(
        friend: Friend? = nil,
        isMyProfile: Bool = false,
        deleteFriendUseCase: DeleteFriendUseCase = DeleteFriendUseCaseImpl(
            friendRepository: FriendRepository(friendService: FriendService())
        ),
        deleteFavoriteFriendUseCase: DeleteFavoriteFriendUseCase = DeleteFavoriteFriendUseCaseImpl(
            friendRepository: FriendRepository(friendService: FriendService())
        ),
        postFavoriteFriendUseCase: PostFavoriteFriendUseCase = PostFavoriteFriendUseCaseImpl(
            friendRepository: FriendRepository(friendService: FriendService())
        )
    ) {
        self.friend = friend
        self.isMyProfile = isMyProfile
        self.deleteFriendUseCase = deleteFriendUseCase
        self.deleteFavoriteFriendUseCase = deleteFavoriteFriendUseCase
        self.postFavoriteFriendUseCase = postFavoriteFriendUseCase
    }
    
    func deleteFriend(completion: @escaping () -> Void) {
        deleteFriendUseCase.execute(request: DeleteFriendBody(memberSeq: memberSeq, friendSeq: friend?.memberSeq ?? 0)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion()
                case .failure:
                    self?.showError = true
                }
            }
        }
    }
    
    func postFavoriteFriend(completion: @escaping () -> Void) {
        postFavoriteFriendUseCase.execute(request: PostFavoriteFriendBody(friendSeq: friend?.memberSeq ?? 0, memberSeq: memberSeq)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion()
                case .failure:
                    self?.showError = true
                }
            }
        }
    }
    
    func deleteFavoriteFriend(completion: @escaping () -> Void) {
        deleteFavoriteFriendUseCase.execute(request: DeleteFavoriteFriendBody(friendSeq: friend?.memberSeq ?? 0, memberSeq: memberSeq)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion()
                case .failure:
                    self?.showError = true
                }
            }
        }
    }
}
