//
//  SendEmailVerificationCodeUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol SendVerificationCodeUseCase {
    func execute(identifier: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void)
}

class SendVerificationCodeUseCaseImpl: SendVerificationCodeUseCase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(identifier: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.sendVerificationCode(identifier: identifier, type: type, completion: completion)
    }
}
