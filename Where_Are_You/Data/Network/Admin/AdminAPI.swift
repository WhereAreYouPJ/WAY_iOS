//
//  AdminAPI.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/5/2025.
//

import Foundation
import Moya

enum AdminAPI {
    case getAdminImage(memberSeq: Int)
    case getServerStatus
}

extension AdminAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getAdminImage:
            return "/admin/image"
        case .getServerStatus:
            return "/actuator/health"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAdminImage, .getServerStatus:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAdminImage(let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getServerStatus:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
