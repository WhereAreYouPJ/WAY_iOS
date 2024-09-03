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
    case postLocation(request: CreateScheduleBody)
    case deleteLocation(request: CreateScheduleBody)
}

extension LocationAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getLocation(let memberSeq):
            return "/location"
        case .postLocation(request: let request):
            return "/location"
        case .deleteLocation(request: let request):
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
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
