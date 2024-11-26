//
//  FriendRequestService.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Alamofire
import Moya

protocol FriendRequestServiceProtocol {
    func getListForReceiver(completion: @escaping (Result<GenericResponse<[GetFriendRequestForReceiverResponse]>, Error>) -> Void)
    func getListForSender(completion: @escaping (Result<GenericResponse<[GetFriendRequestForSenderResponse]>, Error>) -> Void)
    
    func postFriendRequest(request: PostFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
    func acceptFriendRequest(request: AcceptFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
    
    func refuseFriendRequest(request: RefuseFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
    func cancelFriendRequest(request: CancelFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class FriendRequestService: FriendRequestServiceProtocol {
    private var provider = MoyaProvider<FriendRequestAPI>()
    
    private var memberSeq: Int {
        return UserDefaultsManager.shared.getMemberSeq()
    }
    
    init() {
        let tokenPlugin = AuthTokenPlugin(tokenClosure: {
            return UserDefaultsManager.shared.getAccessToken()
        })
        self.provider = MoyaProvider<FriendRequestAPI>(plugins: [tokenPlugin])
    }
    
    func getListForReceiver(completion: @escaping (Result<GenericResponse<[GetFriendRequestForReceiverResponse]>, any Error>) -> Void) {
        provider.request(.getListForReceiver(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    func getListForSender(completion: @escaping (Result<GenericResponse<[GetFriendRequestForSenderResponse]>, any Error>) -> Void) {
        provider.request(.getListForSender(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postFriendRequest(request: PostFriendRequestBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postFriendRequest(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    func acceptFriendRequest(request: AcceptFriendRequestBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.acceptFriendRequest(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func refuseFriendRequest(request: RefuseFriendRequestBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.refuseFriendRequest(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    func cancelFriendRequest(request: CancelFriendRequestBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.cancelFriendRequest(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
