//
//  GetFriendUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 15.11.24.
//

import Foundation

protocol GetFriendUseCase {
    func execute(completion: @escaping (Result<(favorites: [GetFriendResponse], friends: [GetFriendResponse]), Error>) -> Void)
}

class GetFriendUseCaseImpl: GetFriendUseCase {
    private let friendRepository: FriendRepositoryProtocol
    
    init(friendRepository: FriendRepositoryProtocol) {
        self.friendRepository = friendRepository
    }
    
    func execute(completion: @escaping (Result<(favorites: [GetFriendResponse], friends: [GetFriendResponse]), Error>) -> Void) {
        friendRepository.getFriend { result in
            switch result {
            case .success(let response):
                let allFriends = response.data
                let favorites = allFriends.filter { $0.favorites}
                completion(.success((favorites: favorites, friends: allFriends)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
