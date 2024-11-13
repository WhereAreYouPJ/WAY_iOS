//
//  PutScheduleUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/11/2024.
//

import Foundation

protocol PutScheduleUseCase {
    func execute(request: PutScheduleBody, completion: @escaping (Result<GenericResponse<PutScheduleResponse>, Error>) -> Void)
}

class PutScheduleUseCaseImpl: PutScheduleUseCase {
    private let scheduleRepository: ScheduleRepositoryProtocol
    
    init(scheduleRepository: ScheduleRepositoryProtocol) {
        self.scheduleRepository = scheduleRepository
    }
    
    func execute(request: PutScheduleBody, completion: @escaping (Result<GenericResponse<PutScheduleResponse>, any Error>) -> Void) {
        scheduleRepository.putSchedule(request: request, completion: completion)
    }
}
