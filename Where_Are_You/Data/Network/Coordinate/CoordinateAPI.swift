//
//  CoordinateAPI.swift
//  Where_Are_You
//
//  Created by juhee on 09.12.24.
//

import Foundation
import Moya

enum CoordinateAPI {
    case getCoordinate(memberSeq: Int, scheduleSeq: Int)
    case postCoordinate(request: PostCoordinateBody)
}

extension CoordinateAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getCoordinate:
            return "/coordinate"
        case .postCoordinate:
            return "/coordinate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoordinate:
            return .get
        case .postCoordinate:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCoordinate(let memberSeq, let scheduleSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq, "scheduleSeq": scheduleSeq], encoding: URLEncoding.queryString)
        case .postCoordinate(request: let request):
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
