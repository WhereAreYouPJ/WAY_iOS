//
//  PostScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/11/2024.
//

import Foundation

protocol PostScheduleUseCase {
    func execute(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, Error>) -> Void)
}

class PostScheduleUseCaseImpl: PostScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(request: CreateScheduleBody, completion: @escaping (Result<GenericResponse<PostScheduleResponse>, any Error>) -> Void) {
        scheduleRepository.postSchedule(request: request, completion: completion)
    }
}
