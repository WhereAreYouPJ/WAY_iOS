//
//  SignUpUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol SignUpUseCase {
    func execute(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class SignUpUseCaseImpl: SignUpUseCase {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(request: SignUpBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        authRepository.signUp(request: request, completion: completion)
    }
}
