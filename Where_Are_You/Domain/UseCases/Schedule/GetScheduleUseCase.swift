//
//  GetScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/11/2024.
//

import Foundation

protocol GetScheduleUseCase {
    func execute(request: CreateScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class GetScheduleUseCaseImpl: GetScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(request: CreateScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleRepository.getSchedule(request: request, completion: completion)
    }
    
}
