//
//  ScheduleAPI.swift
//  Where_Are_You
//
//  Created by juhee on 09.08.24.
//

import Foundation
import Moya

enum ScheduleAPI {
    case postSchedule(request: CreateScheduleBody)
    case getSchedule(request: CreateScheduleBody)
    case putSchedule(request: CreateScheduleBody)
    case deleteSchedule(request: CreateScheduleBody)
    case postEcceptSchedule(request: CreateScheduleBody)
    case getMonthSchedule(request: CreateScheduleBody)
    case getDate(request: CreateScheduleBody)
    case getDDaySchedule(memberSeq: Int)
}

extension ScheduleAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postSchedule:
            return "/schedule"
        case .getSchedule:
            return "/schedule"
        case .putSchedule:
            return "/schedule"
        case .deleteSchedule:
            return "/schedule"
        case .postEcceptSchedule:
            return "/schedule/accept-schedule"
        case .getMonthSchedule:
            return "/schedule/month-schedule"
        case .getDate:
            return "/schedule/date"
        case .getDDaySchedule:
            return "/schedule/dday-schedule"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSchedule, .postEcceptSchedule:
            return .post
        case .getSchedule, .getMonthSchedule, .getDate, .getDDaySchedule:
            return .get
        case .putSchedule:
            return .put
        case .deleteSchedule:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .postSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .getSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .putSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .deleteSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postEcceptSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .getMonthSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .getDate(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .getDDaySchedule(let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
