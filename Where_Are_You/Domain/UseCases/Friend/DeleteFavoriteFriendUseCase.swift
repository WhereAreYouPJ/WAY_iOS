//
//  DeleteFavoriteFriendUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 19.11.24.
//

import Foundation

protocol DeleteFavoriteFriendUseCase {
    func execute(request: DeleteFavoriteFriendBody,completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteFavoriteFriendUseCaseImpl: DeleteFavoriteFriendUseCase {
    private let friendRepository: FriendRepositoryProtocol
    
    init(friendRepository: FriendRepositoryProtocol) {
        self.friendRepository = friendRepository
    }
    
    func execute(request: DeleteFavoriteFriendBody, completion: @escaping (Result<Void, Error>) -> Void) {
        friendRepository.deleteFavoriteFriend(request: request, completion: completion)
    }
}
