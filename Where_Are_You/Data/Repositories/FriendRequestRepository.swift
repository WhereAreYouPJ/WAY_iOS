//
//  FriendRequestRepository.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Alamofire

protocol FriendRequestRepositoryProtocol {
    func getListForReceiver(completion: @escaping (Result<GenericResponse<[GetFriendRequestForReceiverResponse]>, Error>) -> Void)
    func getListForSender(completion: @escaping (Result<GenericResponse<[GetFriendRequestForSenderResponse]>, Error>) -> Void)
    
    func postFriendRequest(request: PostFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
    func acceptFriendRequest(request: AcceptFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
    
    func refuseFriendRequest(request: RefuseFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
    func cancelFriendRequest(request: CancelFriendRequestBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class FriendRequestRepository: FriendRequestRepositoryProtocol {
    private let friendRequestService: FriendRequestServiceProtocol
    
    init(friendRequestService: FriendRequestServiceProtocol) {
        self.friendRequestService = friendRequestService
    }
    
    func getListForReceiver(completion: @escaping (Result<GenericResponse<[GetFriendRequestForReceiverResponse]>, any Error>) -> Void) {
        friendRequestService.getListForReceiver(completion: completion)
    }
    func getListForSender(completion: @escaping (Result<GenericResponse<[GetFriendRequestForSenderResponse]>, any Error>) -> Void) {
        friendRequestService.getListForSender(completion: completion)
    }
    
    func postFriendRequest(request: PostFriendRequestBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        friendRequestService.postFriendRequest(request: request, completion: completion)
    }
    func acceptFriendRequest(request: AcceptFriendRequestBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        friendRequestService.acceptFriendRequest(request: request, completion: completion)
    }
    
    func refuseFriendRequest(request: RefuseFriendRequestBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        friendRequestService.refuseFriendRequest(request: request, completion: completion)
    }
    func cancelFriendRequest(request: CancelFriendRequestBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        friendRequestService.cancelFriendRequest(request: request, completion: completion)
    }
}
