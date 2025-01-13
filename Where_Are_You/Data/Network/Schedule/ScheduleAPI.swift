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
    case postAcceptSchedule(request: PostAcceptScheduleBody)
    
    case getSchedule(scheduleSeq: Int, memberSeq: Int)
    case getMonthlySchedule(yearMonth: String, memberSeq: Int)
    case getDailySchedule(date: String, memberSeq: Int)
    case getDDaySchedule(memberSeq: Int)
    case getScheduleList(memberSeq: Int, page: Int32)
    case getInvitedList(memberSeq: Int)
    
    case putSchedule(request: PutScheduleBody)
    
    case deleteScheduleByInvitee(request: DeleteScheduleBody)
    case deleteScheduleByCreator(request: DeleteScheduleBody)
    case refuseInvitedSchedule(request: RefuseInvitedScheduleBody)
}

extension ScheduleAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postSchedule, .getSchedule, .putSchedule:
            return "/schedule"
        case .deleteScheduleByInvitee:
            return "/schedule/invited"
        case .deleteScheduleByCreator:
            return "/schedule/creator"
        case .postAcceptSchedule:
            return "/schedule/accept-schedule"
        case .getMonthlySchedule:
            return "/schedule/month"
        case .getDailySchedule:
            return "/schedule/date"
        case .getDDaySchedule:
            return "/schedule/dday"
        case .getScheduleList:
            return "/schedule/list"
        case .getInvitedList:
            return "/schedule/invited-list"
        case .refuseInvitedSchedule:
            return "/schedule/refuse"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSchedule, .postAcceptSchedule:
            return .post
        case .getSchedule, .getMonthlySchedule, .getDailySchedule, .getDDaySchedule, .getScheduleList, .getInvitedList:
            return .get
        case .putSchedule:
            return .put
        case .deleteScheduleByInvitee, .deleteScheduleByCreator, .refuseInvitedSchedule:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .postSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postAcceptSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
            
        case .getSchedule(let scheduleSeq, let memberSeq):
            return .requestParameters(parameters: ["scheduleSeq": scheduleSeq, "memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getMonthlySchedule(let yearMonth, let memberSeq):
            return .requestParameters(parameters: ["yearMonth": yearMonth, "memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getDailySchedule(let date, let memberSeq):
            return .requestParameters(parameters: ["date": date, "memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getDDaySchedule(let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getScheduleList(let memberSeq, let page):
            return .requestParameters(parameters: ["memberSeq": memberSeq, "page": page], encoding: URLEncoding.queryString)
        case .getInvitedList(let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
            
        case .putSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
            
        case .deleteScheduleByInvitee(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .deleteScheduleByCreator(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .refuseInvitedSchedule(request: let request):
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
