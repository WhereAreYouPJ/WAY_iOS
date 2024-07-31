//
//  CheckEmailAvailabilityUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol CheckEmailAvailabilityUseCase {
    func execute(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class CheckEmailAvailabilityUseCaseImpl: CheckEmailAvailabilityUseCase {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        authRepository.checkEmailAvailability(email: email, completion: completion)
    }
}
