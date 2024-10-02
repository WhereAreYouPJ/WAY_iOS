//
//  GetScheduleListUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/9/2024.
//

import Foundation

protocol GetScheduleListUseCase {
    func execute(page: Int32, completion: @escaping (Result<[ScheduleContent], Error>) -> Void)

}


class GetScheduleListUseCaseImpl: GetScheduleListUseCase {
    
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(page: Int32, completion: @escaping (Result<[ScheduleContent], any Error>) -> Void) {
        scheduleRepository.getScheduleList(page: page) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data.content))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
