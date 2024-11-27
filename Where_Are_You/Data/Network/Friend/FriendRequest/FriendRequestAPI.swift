//
//  FriendRequestAPI.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Moya

enum FriendRequestAPI {
    case getListForReceiver(memberSeq: Int)
    case getListForSender(memberSeq: Int)
    case postFriendRequest(request: PostFriendRequestBody)
    case acceptFriendRequest(request: AcceptFriendRequestBody)
    case refuseFriendRequest(request: RefuseFriendRequestBody)
    case cancelFriendRequest(request: CancelFriendRequestBody)
}

extension FriendRequestAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getListForReceiver:
            return "/friend-request"
        case .getListForSender:
            return "/friend-request/list"
        case .postFriendRequest:
            return "/friend-request"
        case .acceptFriendRequest:
            return "/friend-request/accept"
        case .refuseFriendRequest:
            return "/friend-request/refuse"
        case .cancelFriendRequest:
            return "/friend-request/cancel"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListForReceiver, .getListForSender:
            return .get
        case .postFriendRequest, .acceptFriendRequest:
            return .post
        case .refuseFriendRequest, .cancelFriendRequest:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getListForReceiver(memberSeq: let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getListForSender(memberSeq: let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
            
        case .postFriendRequest(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .acceptFriendRequest(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
            
        case .refuseFriendRequest(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .cancelFriendRequest(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
