//
//  FriendService.swift
//  Where_Are_You
//
//  Created by juhee on 15.11.24.
//

import Alamofire
import Moya

protocol FriendServiceProtocol {
    func getFriend(completion: @escaping (Result<[GetFriendResponse], Error>) -> Void)
    func deleteFriend(request: DeleteFriendBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postFavoriteFriend(request: PostFavoriteFriendBody, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteFavoriteFriend(request: DeleteFavoriteFriendBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class FriendService: FriendServiceProtocol {
    private var provider = MoyaProvider<FriendAPI>()
    
    private var memberSeq: Int {
        return UserDefaultsManager.shared.getMemberSeq()
    }
    
    init() {
        let tokenPlugin = AuthTokenPlugin(tokenClosure: {
            return UserDefaultsManager.shared.getAccessToken()
        })
        self.provider = MoyaProvider<FriendAPI>(plugins: [tokenPlugin])
    }
    
    func getFriend(completion: @escaping (Result<[GetFriendResponse], any Error>) -> Void) {
        provider.request(.getFriend(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func deleteFriend(request: DeleteFriendBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteFriend(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postFavoriteFriend(request: PostFavoriteFriendBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postFavoriteFriend(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func deleteFavoriteFriend(request: DeleteFavoriteFriendBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteFavoriteFriend(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    
}
