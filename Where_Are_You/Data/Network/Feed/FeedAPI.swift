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
    case deleteFeed(request: DeleteFeedRequest)
    case getFeedList(memberSeq: Int, page: Int32)
    case getFeedDetails(memberSeq: Int, scheduleSeq: Int)
    
    case getBookMarkFeed(memberSeq: Int, page: Int32)
    case postBookMarkFeed(request: BookMarkFeedRequest)
    case deleteBookMarkFeed(request: BookMarkFeedRequest)
}

extension FeedAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .putFeed, .postFeed, .deleteFeed:
            return "/feed"
        case .getFeedList:
            return "/feed/list"
        case .getFeedDetails:
            return "/feed/details"
        case .getBookMarkFeed, .postBookMarkFeed, .deleteBookMarkFeed:
            return "/book-mark"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .putFeed:
            return .put
        case .postFeed, .postBookMarkFeed:
            return .post
        case .getBookMarkFeed, .getFeedList, .getFeedDetails:
            return .get
        case .deleteBookMarkFeed, .deleteFeed:
            return .delete
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
        case .deleteFeed(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .getFeedList(let memberSeq, let page):
            return .requestParameters(parameters: ["memberSeq": memberSeq, "page": page], encoding: URLEncoding.queryString)
        case .getFeedDetails(let memberSeq, let scheduleSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq, "scheduleSeq": scheduleSeq], encoding: URLEncoding.queryString)
            
        case .getBookMarkFeed(let memberSeq, let page):
            return .requestParameters(parameters: ["memberSeq": memberSeq, "page": page], encoding: URLEncoding.queryString)
        case .postBookMarkFeed(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .deleteBookMarkFeed(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "multipart/form-data"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
