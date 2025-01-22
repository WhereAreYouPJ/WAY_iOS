//
//  GetInvitedListUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 13.01.25.
//

import Foundation

protocol GetInvitedListUseCase {
    func execute(completion: @escaping (Result<GetInvitedListResponse, Error>) -> Void)
}

class GetInvitedListUseCaseImpl: GetInvitedListUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(completion: @escaping (Result<GetInvitedListResponse, Error>) -> Void) {
        scheduleRepository.getInvitedList { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
