//
//  DeleteInvitedScheduleUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 13.01.25.
//

import Foundation

protocol DeleteInvitedScheduleUseCase {
    func execute(request: DeleteInvitedScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteInvitedScheduleUseCaseImpl: DeleteInvitedScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(request: DeleteInvitedScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleRepository.deleteInvitedSchedule(request: request, completion: completion)
    }
}
