//
//  GetDDayScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/9/2024.
//

import Foundation

protocol GetDDayScheduleUseCase {
    func execute(completion: @escaping (Result<[DDayScheduleResponse], Error>) -> Void)
}

class GetDDayScheduleUseCaseImpl: GetDDayScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(completion: @escaping (Result<[DDayScheduleResponse], any Error>) -> Void) {
        scheduleRepository.getDDaySchedule { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
