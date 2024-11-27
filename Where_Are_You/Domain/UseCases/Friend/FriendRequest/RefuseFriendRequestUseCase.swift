//
//  RefuseFriendRequestUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 27.11.24.
//

import Foundation

protocol RefuseFriendRequestUseCase {
    func execute(request: RefuseFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class RefuseFriendRequestUseCaseImpl: RefuseFriendRequestUseCase {
    private let repository: FriendRequestRepositoryProtocol
    
    init(repository: FriendRequestRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(request: RefuseFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.refuseFriendRequest(request: request, completion: completion)
    }
}
