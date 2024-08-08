//
//  ScheduleAPI.swift
//  Where_Are_You
//
//  Created by juhee on 09.08.24.
//

import Moya

enum ScheduleAPI {
    case postSchedule(request: CreateScheduleBody)
    case getSchedule(request: CreateScheduleBody)
    case putSchedule(request: CreateScheduleBody)
    case deleteSchedule(request: CreateScheduleBody)
    case postEcceptSchedule(requst: CreateScheduleBody)
    case getMonthSchedule(request: CreateScheduleBody)
    case getDate(request: CreateScheduleBody)
}

extension ScheduleAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postSchedule:
            return "/schedule"
        case .getSchedule(request: let request):
            <#code#>
        case .putSchedule(request: let request):
            <#code#>
        case .deleteSchedule(request: let request):
            <#code#>
        case .postEcceptSchedule(requst: let requst):
            <#code#>
        case .getMonthSchedule(request: let request):
            <#code#>
        case .getDate(request: let request):
            <#code#>
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSchedule, .postEcceptSchedule:
            return .post
        case .getSchedule, .getMonthSchedule, .getDate:
            return .get
        case .putSchedule(request: let request):
            return .put
        case .deleteSchedule(request: let request):
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .postSchedule(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .getSchedule(request: let request):
            <#code#>
        case .putSchedule(request: let request):
            <#code#>
        case .deleteSchedule(request: let request):
            <#code#>
        case .postEcceptSchedule(requst: let requst):
            <#code#>
        case .getMonthSchedule(request: let request):
            <#code#>
        case .getDate(request: let request):
            <#code#>
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
