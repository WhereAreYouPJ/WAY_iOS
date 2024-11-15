//
//  FriendRepository.swift
//  Where_Are_You
//
//  Created by juhee on 15.11.24.
//

import Alamofire

protocol FriendRepositoryProtocol {
    func getFriends(completion: @escaping (Result<[GetFriendResponse], Error>) -> Void)
    func deleteFriend(request: DeleteFriendBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postFavoriteFriend(request: PostFavoriteFriendBody, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteFavoriteFriend(request: DeleteFavoriteFriendBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class FriendRepository: FriendRepositoryProtocol {
    private let friendService: FriendServiceProtocol
    
    init(friendService: FriendServiceProtocol) {
        self.friendService = friendService
    }
    
    func getFriends(completion: @escaping (Result<[GetFriendResponse], any Error>) -> Void) {
        friendService.getFriend(completion: completion)
    }
    
    func deleteFriend(request: DeleteFriendBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        friendService.deleteFriend(request: request, completion: completion)
    }
    
    func postFavoriteFriend(request: PostFavoriteFriendBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        friendService.postFavoriteFriend(request: request, completion: completion)
    }
    
    func deleteFavoriteFriend(request: DeleteFavoriteFriendBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        friendService.deleteFavoriteFriend(request: request, completion: completion)
    }
    
    
}
