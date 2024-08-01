//
//  ResetPasswordUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/7/2024.
//

import Foundation

protocol ResetPasswordUseCase {
    func execute(email: String, password: String, checkPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class ResetPasswordUseCaseImpl: ResetPasswordUseCase {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String, checkPassword: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        authRepository.resetPassword(email: email, password: password, checkPassword: checkPassword, completion: completion)
    }
}
