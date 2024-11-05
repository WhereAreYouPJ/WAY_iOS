//
//  LocationAPI.swift
//  Where_Are_You
//
//  Created by juhee on 01.09.24.
//

import Foundation
import Moya

enum LocationAPI {
    case getLocation(memberSeq: Int)
    case postLocation(request: PostFavoriteLocationBody)
    case deleteLocation(request: DeleteFavoriteLocationBody)
    case putLocation(memberSeq: Int, request: PutFavoriteLocationRequest)
}

extension LocationAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getLocation:
            return "/location"
        case .postLocation:
            return "/location"
        case .deleteLocation:
            return "/location"
        case .putLocation:
            return "/location"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postLocation:
            return .post
        case .getLocation:
            return .get
        case .deleteLocation:
            return .delete
        case .putLocation:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getLocation(let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .postLocation(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .deleteLocation(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .putLocation(let memberSeq, request: let request):
            let parameters = ["memberSeq": memberSeq]
            // JSON 배열을 데이터로 인코딩
            let bodyData = try? JSONSerialization.data(withJSONObject: request.map { $0.toParameters() }, options: [])
            return .requestCompositeData(bodyData: bodyData ?? Data(), urlParameters: parameters)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
