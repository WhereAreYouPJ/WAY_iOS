//
//  ScheduleRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/9/2024.
//

import Foundation

protocol ScheduleRepositoryProtocol {
    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, Error>) -> Void)
    func postAcceptSchedule(request: PostAcceptScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getSchedule(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetScheduleResponse>, Error>) -> Void)
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<GenericResponse<[GetScheduleByMonthResponse]>, Error>) -> Void)
    func getDailySchedule(date: String, memberSeq: Int, completion: @escaping (Result<GenericResponse<[GetScheduleByDateResponse]>, Error>) -> Void)
    func getDDaySchedule(completion: @escaping (Result<GenericResponse<[DDayScheduleResponse]>, Error>) -> Void)
    func getScheduleList(page: Int32, completion: @escaping (Result<GenericResponse<GetScheduleListResponse>, Error>) -> Void)
    func getInvitedList(completion: @escaping (Result<GenericResponse<GetInvitedListResponse>, Error>) -> Void)
    
    func putSchedule(request: PutScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteSchedule(request: DeleteScheduleBody, isCreator: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func refuseInvitedSchedule(request: RefuseInvitedScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class ScheduleRepository: ScheduleRepositoryProtocol {
    // MARK: - Properties

    private let scheduleService: ScheduleServiceProtocol

    init(scheduleService: ScheduleServiceProtocol) {
        self.scheduleService = scheduleService
    }
    
    // MARK: - POST
    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, any Error>) -> Void) {
        scheduleService.postSchedule(request: request, completion: completion)
    }
    
    func postAcceptSchedule(request: PostAcceptScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleService.postAcceptSchedule(request: request, completion: completion)
    }
    
    // MARK: GET
    func getSchedule(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetScheduleResponse>, any Error>) -> Void) {
        scheduleService.getSchedule(scheduleSeq: scheduleSeq, completion: completion)
    }
    
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<GenericResponse<[GetScheduleByMonthResponse]>, Error>) -> Void) {
        scheduleService.getMonthlySchedule(yearMonth: yearMonth, completion: completion)
    }
    
    func getDailySchedule(date: String, memberSeq: Int, completion: @escaping (Result<GenericResponse<[GetScheduleByDateResponse]>, Error>) -> Void) {
        scheduleService.getDailySchedule(date: date, memberSeq: memberSeq, completion: completion)
    }
    
    func getDDaySchedule(completion: @escaping (Result<GenericResponse<[DDayScheduleResponse]>, any Error>) -> Void) {
        scheduleService.getDDaySchedule(completion: completion)
    }
    
    func getScheduleList(page: Int32, completion: @escaping (Result<GenericResponse<GetScheduleListResponse>, any Error>) -> Void) {
        scheduleService.getScheduleList(page: page, completion: completion)
    }
    
    func getInvitedList(completion: @escaping (Result<GenericResponse<GetInvitedListResponse>, any Error>) -> Void) {
        scheduleService.getInvitedList(completion: completion)
    }
    
    // MARK: PUT
    func putSchedule(request: PutScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleService.putSchedule(request: request, completion: completion)
    }
    
    // MARK: DELETE
    func deleteSchedule(request: DeleteScheduleBody, isCreator: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if isCreator {
            scheduleService.deleteScheduleByCreator(request: request, completion: completion)
        } else {
            scheduleService.deleteScheduleByInvitee(request: request, completion: completion)
        }
    }
    
    func refuseInvitedSchedule(request: RefuseInvitedScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleService.refuseInvitedSchedule(request: request, completion: completion)
    }
}
