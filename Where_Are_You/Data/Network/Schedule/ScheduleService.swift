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
    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, Error>) -> Void)
    func postAcceptSchedule(request: PostAcceptScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getSchedule(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetScheduleResponse>, Error>) -> Void)
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<GenericResponse<[GetScheduleByMonthResponse]>, Error>) -> Void)
    func getDailySchedule(date: String, memberSeq: Int, completion: @escaping (Result<GenericResponse<[GetScheduleByDateResponse]>, Error>) -> Void)
    func getDDaySchedule(completion: @escaping (Result<GenericResponse<[DDayScheduleResponse]>, Error>) -> Void)
    func getScheduleList(page: Int32, completion: @escaping (Result<GenericResponse<GetScheduleListResponse>, Error>) -> Void)
    func getInvitedList(completion: @escaping (Result<GenericResponse<GetInvitedListResponse>, Error>) -> Void)
    
    func putSchedule(request: PutScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteScheduleByInvitee(request: DeleteScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteScheduleByCreator(request: DeleteScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func refuseInvitedSchedule(request: RefuseInvitedScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    // MARK: - POST
    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, any Error>) -> Void) {
        provider.request(.postSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postAcceptSchedule(request: PostAcceptScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postAcceptSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    // MARK: GET
    func getSchedule(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetScheduleResponse>, any Error>) -> Void) {
        provider.request(.getSchedule(scheduleSeq: scheduleSeq, memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<GenericResponse<[GetScheduleByMonthResponse]>, Error>) -> Void) {
        provider.request(.getMonthlySchedule(yearMonth: yearMonth, memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getDailySchedule(date: String, memberSeq: Int, completion: @escaping (Result<GenericResponse<[GetScheduleByDateResponse]>, Error>) -> Void) {
        provider.request(.getDailySchedule(date: date, memberSeq: memberSeq)) { result in
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
    
    func getInvitedList(completion: @escaping (Result<GenericResponse<GetInvitedListResponse>, any Error>) -> Void) {
        provider.request(.getInvitedList(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    // MARK: PUT
    func putSchedule(request: PutScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.putSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    // MARK: DELETE
    func deleteScheduleByInvitee(request: DeleteScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteScheduleByInvitee(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func deleteScheduleByCreator(request: DeleteScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteScheduleByCreator(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func refuseInvitedSchedule(request: RefuseInvitedScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.refuseInvitedSchedule(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
