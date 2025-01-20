//
//  AcceptFriendRequestUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 27.11.24.
//

import Foundation

protocol AcceptFriendRequestUseCase {
    func execute(request: AcceptFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class AcceptFriendRequestUseCaseImpl: AcceptFriendRequestUseCase {
    private let repository: FriendRequestRepositoryProtocol
    
    init(repository: FriendRequestRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(request: AcceptFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.acceptFriendRequest(request: request, completion: completion)
    }
}
