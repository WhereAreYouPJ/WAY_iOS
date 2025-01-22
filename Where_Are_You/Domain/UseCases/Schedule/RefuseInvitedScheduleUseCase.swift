//
//  DeleteInvitedScheduleUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 13.01.25.
//

import Foundation

protocol RefuseInvitedScheduleUseCase {
    func execute(request: RefuseInvitedScheduleBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class RefuseInvitedScheduleUseCaseImpl: RefuseInvitedScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(request: RefuseInvitedScheduleBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        scheduleRepository.refuseInvitedSchedule(request: request, completion: completion)
    }
}
