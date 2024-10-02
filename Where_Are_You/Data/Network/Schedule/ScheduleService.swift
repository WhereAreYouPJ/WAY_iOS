//
//  ScheduleService.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/9/2024.
//

import Alamofire
import Moya

// MARK: - ScheduleServiceProtocol

protocol ScheduleServiceProtocol {
    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func getSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func putSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postEcceptSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<GenericResponse<[GetScheduleByMonthResponse]>, Error>) -> Void)
    func getDate(request: CreateScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func getDDaySchedule(completion: @escaping (Result<GenericResponse<[DDayScheduleResponse]>, Error>) -> Void)
    func getScheduleList(page: Int32, completion: @escaping (Result<GenericResponse<GetScheduleListResponse>, Error>) -> Void)
}

// MARK: - ScheduleService

class ScheduleService: ScheduleServiceProtocol {

    private var provider = MoyaProvider<ScheduleAPI>()
    
    private var memberSeq: Int {
        return UserDefaultsManager.shared.getMemberSeq()
    }
    
    init() {
        let tokenPlugin = AuthTokenPlugin(tokenClosure: {
            return UserDefaultsManager.shared.getAccessToken()
        })
        self.provider = MoyaProvider<ScheduleAPI>(plugins: [tokenPlugin])
    }
    
    // MARK: - APIService
    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.getSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func putSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.putSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func deleteSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postEcceptSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postEcceptSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<GenericResponse<[GetScheduleByMonthResponse]>, Error>) -> Void) {
        provider.request(.getMonthlySchedule(yearMonth: yearMonth, memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getDate(request: CreateScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.getDate(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getDDaySchedule(completion: @escaping (Result<GenericResponse<[DDayScheduleResponse]>, Error>) -> Void) {
        provider.request(.getDDaySchedule(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getScheduleList(page: Int32, completion: @escaping (Result<GenericResponse<GetScheduleListResponse>, any Error>) -> Void) {
        provider.request(.getScheduleList(memberSeq: memberSeq, page: page)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
