//
//  PostFriendRequestUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 27.11.24.
//

import Foundation

protocol PostFriendRequestUseCase {
    func execute(request: PostFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class PostFriendRequestUseCaseImpl: PostFriendRequestUseCase {
    private let repository: FriendRequestRepositoryProtocol
    
    init(repository: FriendRequestRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(request: PostFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.postFriendRequest(request: request, completion: completion)
    }
}
