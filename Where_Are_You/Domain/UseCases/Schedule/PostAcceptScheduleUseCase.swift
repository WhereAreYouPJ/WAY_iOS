//
//  PostEcceptScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/11/2024.
//

import Foundation

protocol PostAcceptScheduleUseCase {
    func execute(request: PostAcceptScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class PostEcceptScheduleUseCaseImpl: PostAcceptScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(request: PostAcceptScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleRepository.postAcceptSchedule(request: request, completion: completion)
    }
}
