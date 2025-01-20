//
//  ScheduleRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/9/2024.
//

import Foundation

protocol ScheduleRepositoryProtocol {
    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, Error>) -> Void)
    func getSchedule(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetScheduleResponse>, Error>) -> Void)
    func putSchedule(request: PutScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteSchedule(request: DeleteScheduleBody, isCreator: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func postEcceptSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<GenericResponse<[GetScheduleByMonthResponse]>, Error>) -> Void)
    func getDailySchedule(date: String, completion: @escaping (Result<GenericResponse<GetScheduleByDateResponse>, Error>) -> Void)
    func getDDaySchedule(completion: @escaping (Result<GenericResponse<[DDayScheduleResponse]>, Error>) -> Void)
    func getScheduleList(page: Int32, completion: @escaping (Result<GenericResponse<GetScheduleListResponse>, Error>) -> Void)
}

class ScheduleRepository: ScheduleRepositoryProtocol {
    // MARK: - Properties

    private let scheduleService: ScheduleServiceProtocol

    init(scheduleService: ScheduleServiceProtocol) {
        self.scheduleService = scheduleService
    }

    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, any Error>) -> Void) {
        scheduleService.postSchedule(request: request, completion: completion)
    }
 
    func getSchedule(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetScheduleResponse>, any Error>) -> Void) {
        scheduleService.getSchedule(scheduleSeq: scheduleSeq, completion: completion)
    }
    
    func putSchedule(request: PutScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleService.putSchedule(request: request, completion: completion)
    }
    
    func deleteSchedule(request: DeleteScheduleBody, isCreator: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if isCreator {
            scheduleService.deleteScheduleByCreator(request: request, completion: completion)
        } else {
            scheduleService.deleteScheduleByInvitee(request: request, completion: completion)
        }
    }
    
    func postEcceptSchedule(request: CreateScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleService.postEcceptSchedule(request: request, completion: completion)
    }
    
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<GenericResponse<[GetScheduleByMonthResponse]>, Error>) -> Void) {
        scheduleService.getMonthlySchedule(yearMonth: yearMonth, completion: completion)
    }
    
    func getDailySchedule(date: String, completion: @escaping (Result<GenericResponse<GetScheduleByDateResponse>, Error>) -> Void) {
        scheduleService.getDailySchedule(date: date, completion: completion)
    }
    
    func getDDaySchedule(completion: @escaping (Result<GenericResponse<[DDayScheduleResponse]>, any Error>) -> Void) {
        scheduleService.getDDaySchedule(completion: completion)
    }
    
    func getScheduleList(page: Int32, completion: @escaping (Result<GenericResponse<GetScheduleListResponse>, any Error>) -> Void) {
        scheduleService.getScheduleList(page: page, completion: completion)
    }
}
