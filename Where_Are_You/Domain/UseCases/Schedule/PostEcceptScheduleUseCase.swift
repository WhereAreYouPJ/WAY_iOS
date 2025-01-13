//
//  PostEcceptScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/11/2024.
//

import Foundation

protocol PostEcceptScheduleUseCase {
    func execute(request: PostEcceptScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class PostEcceptScheduleUseCaseImpl: PostEcceptScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(request: PostEcceptScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleRepository.postEcceptSchedule(request: request, completion: completion)
    }
}
