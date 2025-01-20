//
//  DeleteScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/11/2024.
//

import Foundation

protocol DeleteScheduleUseCase {
    func execute(request: DeleteScheduleBody, isCreator: Bool, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteScheduleUseCaseImpl: DeleteScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(request: DeleteScheduleBody, isCreator: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleRepository.deleteSchedule(request: request, isCreator: isCreator, completion: completion)
    }
}
