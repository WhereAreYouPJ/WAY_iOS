//
//  ResetPasswordUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/7/2024.
//

import Foundation

protocol ResetPasswordUseCase {
    func execute(userId: String, password: String, checkPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class ResetPasswordUseCaseImpl: ResetPasswordUseCase {
    private let userRepository: AuthRepositoryProtocol
    
    init(userRepository: AuthRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(userId: String, password: String, checkPassword: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        userRepository.resetPassword(userId: userId, password: password, checkPassword: checkPassword, completion: completion)
    }
}
