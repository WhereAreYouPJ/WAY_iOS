//
//  SendEmailVerificationCodeUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol SendEmailVerificationCodeUseCase {
    func execute(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func execute(userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class SendEmailVerificationCodeUseCaseImpl: SendEmailVerificationCodeUseCase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.sendEmailVerificationCode(email: email, completion: completion)
    }
    
    func execute(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.sendEmailVerificationCode(userId: userId, completion: completion)
    }
}
