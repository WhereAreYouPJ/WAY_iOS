//
//  PostFavoriteFriendUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 19.11.24.
//

import Foundation

protocol PostFavoriteFriendUseCase {
    func execute(request: PostFavoriteFriendBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class PostFavoriteFriendUseCaseImpl: PostFavoriteFriendUseCase {
    private let friendRepository: FriendRepositoryProtocol
    
    init(friendRepository: FriendRepositoryProtocol) {
        self.friendRepository = friendRepository
    }
    
    func execute(request: PostFavoriteFriendBody, completion: @escaping (Result<Void, Error>) -> Void) {
        friendRepository.postFavoriteFriend(request: request, completion: completion)
    }
}
