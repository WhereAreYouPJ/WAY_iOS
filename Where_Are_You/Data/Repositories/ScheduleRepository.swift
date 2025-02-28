//
//  ScheduleRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/9/2024.
//

import Foundation

// TODO: API Response to App Entity 데이터 변환
protocol ScheduleRepositoryProtocol {
    func postSchedule(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, Error>) -> Void)
    func postAcceptSchedule(request: PostAcceptScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getSchedule(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetScheduleResponse>, Error>) -> Void)
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<[Schedule], Error>) -> Void)
    func getDailySchedule(date: String, completion: @escaping (Result<GenericResponse<GetScheduleByDateResponse>, Error>) -> Void)
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
    
    func getMonthlySchedule(yearMonth: String, completion: @escaping (Result<[Schedule], Error>) -> Void) {
        scheduleService.getMonthlySchedule(yearMonth: yearMonth) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let schedules = self.convertToSchedules(from: response.data)
                completion(.success(schedules))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
    
    // MARK: Converter
    private func convertToSchedules(from schedules: GetScheduleByMonthResponse) -> [Schedule] {
        return schedules.compactMap { response -> Schedule? in
            guard let startTime = response.startTime.toDate(from: .serverSimple),
                  let endTime = response.endTime.toDate(from: .serverSimple) else {
                print("startTime or endTime 변환 실패: \(response.startTime)")
                return nil
            }
            
            return Schedule(
                scheduleSeq: response.scheduleSeq,
                title: response.title,
                startTime: startTime,
                endTime: endTime,
                isAllday: response.allDay,
                location: Location(
                    sequence: 0,
                    location: response.location ?? "",
                    streetName: response.streetName ?? "",
                    x: response.x ?? 0,
                    y: response.y ?? 0
                ),
                color: response.color,
                memo: response.memo
            )
        }
    }
}
