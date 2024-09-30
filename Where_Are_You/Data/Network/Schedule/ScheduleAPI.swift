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
    case getMonthlySchedule(yearMonth: String, memberSeq: Int)
    case getDate(request: CreateScheduleBody)
    case getDDaySchedule(memberSeq: Int)
    case getScheduleList(memberSeq: Int, page: Int32)
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
        case .getMonthlySchedule:
            return "/schedule/month"
        case .getDate:
            return "/schedule/date"
        case .getDDaySchedule:
            return "/schedule/dday"
        case .getScheduleList:
            return "/schedule/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSchedule, .postEcceptSchedule:
            return .post
        case .getSchedule, .getMonthlySchedule, .getDate, .getDDaySchedule, .getScheduleList:
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
        case .getMonthlySchedule(let yearMonth, let memberSeq):
            return .requestParameters(parameters: ["yearMonth": yearMonth, "memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getDate(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .getDDaySchedule(let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getScheduleList(let memberSeq, let page):
            return .requestParameters(parameters: ["memberSeq": memberSeq, "page": page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
