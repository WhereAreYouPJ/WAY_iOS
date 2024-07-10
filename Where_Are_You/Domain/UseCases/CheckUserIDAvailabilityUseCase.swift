//
//  CheckUserIDAvailabilityUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol CheckUserIDAvailabilityUseCase {
    func execute(userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class CheckUserIDAvailabilityUseCaseImpl: CheckUserIDAvailabilityUseCase {
    private let userRepository: AuthRepositoryProtocol
    
    init(userRepository: AuthRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(userId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        userRepository.checkUserIDAvailability(userId: userId, completion: completion)
    }
}
