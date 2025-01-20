//
//  GetScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/11/2024.
//

import Foundation

protocol GetScheduleUseCase {
    func execute(scheduleSeq: Int, completion: @escaping (Result<GetScheduleResponse, Error>) -> Void)

}

class GetScheduleUseCaseImpl: GetScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(scheduleSeq: Int, completion: @escaping (Result<GetScheduleResponse, any Error>) -> Void) {
        scheduleRepository.getSchedule(scheduleSeq: scheduleSeq) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
