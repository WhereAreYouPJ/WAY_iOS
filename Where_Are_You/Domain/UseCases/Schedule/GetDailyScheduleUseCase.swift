//
//  GetDailyScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 20/1/2025.
//

import Foundation

protocol GetDailyScheduleUseCase {
    func execute(date: String, completion: @escaping (Result<GetScheduleByDateResponse, Error>) -> Void)
}

class GetDailyScheduleUseCaseImpl: GetDailyScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(date: String, completion: @escaping (Result<GetScheduleByDateResponse, Error>) -> Void) {
        scheduleRepository.getDailySchedule(date: date) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
