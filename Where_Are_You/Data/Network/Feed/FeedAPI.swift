//
//  FeedAPI.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Moya

enum FeedAPI {
    case putFeed(request: ModifyFeedRequest, images: [UIImage]?)
    case postFeed(request: SaveFeedRequest, images: [UIImage]?)
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
        case .putFeed:
            return .put
        case .postFeed:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .putFeed(let request, let images):
            let multipartData = MultipartFormDataHelper.createMultipartData(from: request, images: images)
            return .uploadMultipart(multipartData)
        case .postFeed(let request, let images):
            let multipartData = MultipartFormDataHelper.createMultipartData(from: request, images: images)
            return .uploadMultipart(multipartData)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "multipart/form-data"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
