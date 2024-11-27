//
//  FriendAPI.swift
//  Where_Are_You
//
//  Created by juhee on 15.11.24.
//

import Moya

enum FriendAPI {
    case getFriend(memberSeq: Int)
    case deleteFriend(request: DeleteFriendBody)
    case postFavoriteFriend(request: PostFavoriteFriendBody)
    case deleteFavoriteFriend(request: DeleteFavoriteFriendBody)
}

extension FriendAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getFriend:
            return "/friend"
        case .deleteFriend(request: let request):
            return "/friend"
        case .postFavoriteFriend(request: let request):
            return "/friend/favorites"
        case .deleteFavoriteFriend(request: let request):
            return "/friend/favorites"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFriend:
            return .get
        case .deleteFriend, .deleteFavoriteFriend:
            return .delete
        case .postFavoriteFriend:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getFriend(memberSeq: let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .deleteFriend(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postFavoriteFriend(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .deleteFavoriteFriend(request: let request):
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
