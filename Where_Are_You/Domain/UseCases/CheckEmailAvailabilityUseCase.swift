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
    private let userRepository: AuthRepositoryProtocol
    
    init(userRepository: AuthRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(email: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        userRepository.checkEmailAvailability(email: email, completion: completion)
    }
}
