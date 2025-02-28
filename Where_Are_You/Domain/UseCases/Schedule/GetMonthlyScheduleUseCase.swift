//
//  GetMonthlyScheduleUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 27.02.25.
//

import Foundation

protocol GetMonthlyScheduleUseCase {
    func execute(yearMonth: String, completion: @escaping (Result<[Schedule], Error>) -> Void)
}

class GetMonthlyScheduleUseCaseImpl: GetMonthlyScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(yearMonth: String, completion: @escaping (Result<[Schedule], Error>) -> Void) {
        scheduleRepository.getMonthlySchedule(yearMonth: yearMonth, completion: completion)
    }
}
