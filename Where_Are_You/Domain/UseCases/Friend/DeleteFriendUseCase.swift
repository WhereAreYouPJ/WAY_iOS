//
//  DeleteFriendUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 19.11.24.
//

import Foundation

protocol DeleteFriendUseCase {
    func execute(request: DeleteFriendBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteFriendUseCaseImpl: DeleteFriendUseCase {
    private let friendRepository: FriendRepositoryProtocol
    
    init(friendRepository: FriendRepositoryProtocol) {
        self.friendRepository = friendRepository
    }
    
    func execute(request: DeleteFriendBody, completion: @escaping (Result<Void, Error>) -> Void) {
        friendRepository.deleteFriend(request: request, completion: completion)
    }
}
