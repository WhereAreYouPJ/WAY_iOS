//
//  FeedAPI.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Moya

enum FeedAPI {
    case updateFeed(request: ModifyFeedRequest, images: [UIImage]?)
    case createFeed(request: SaveFeedRequest, images: [UIImage]?)
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
            //        case .updateFeed(let request):
            //            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
            //        case .createFeed(let request):
            //            // 이미지가 있는 경우 멀티파트 폼 데이터로 처리
            //            if let images = images, !images.isEmpty {
            //                let multipartData = MultipartFormDataHelper.createMultipartData(from: request, images: images)
            //                return .uploadMultipart(multipartData)
            //            } else {
            //                // 이미지가 없으면 텍스트 데이터만 JSON으로 전송
            //                return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
            //            }
        case .updateFeed(let request, let images):
            let multipartData = MultipartFormDataHelper.createMultipartData(from: request, images: images)
            return .uploadMultipart(multipartData)
        case .createFeed(let request, let images):
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
