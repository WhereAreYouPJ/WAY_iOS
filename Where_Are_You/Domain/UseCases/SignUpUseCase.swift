//
//  SignUpUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol SignUpUseCase {
    func execute(request: AuthCredentials, completion: @escaping (Result<Void, Error>) -> Void)
}

class SignUpUseCaseImpl: SignUpUseCase {
    private let userRepository: AuthRepositoryProtocol
    
    init(userRepository: AuthRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(request: AuthCredentials, completion: @escaping (Result<Void, any Error>) -> Void) {
        userRepository.signUp(request: request, completion: completion)
    }
}
