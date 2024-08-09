//
//  FeedAPI.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Moya

enum FeedAPI {
    case updateFeed(request: UpdateFeedBody)
    case createFeed(request: CreateFeedBody)
}

extension FeedAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        return "/feed"
    }
    
    var method: Moya.Method {
        switch self {
        case .updateFeed:
            return .put
        case .createFeed:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .updateFeed(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .createFeed(let request):
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
