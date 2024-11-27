//
//  CancelFriendRequestUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 27.11.24.
//

import Foundation

protocol CancelFriendRequestUseCase {
    func execute(request: CancelFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class CancelFriendRequestUseCaseImpl: CancelFriendRequestUseCase {
    private let repository: FriendRequestRepositoryProtocol
    
    init(repository: FriendRequestRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(request: CancelFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.cancelFriendRequest(request: request, completion: completion)
    }
}
