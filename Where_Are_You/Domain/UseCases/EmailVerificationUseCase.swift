//
//  EmailVerificationUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

protocol EmailVerificationUseCase {
    func sendVerificaitonCode(to email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyCode(for email: String, code: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func findAccount(by email: String, completion: @escaping (Result<String, Error>) -> Void)
}

class EmailVerificationUseCaseImpl: EmailVerificationUseCase {
    private let emailVerificationRepository: EmailVerificationRepository
    
    init(emailVerificationRepository: EmailVerificationRepository) {
        self.emailVerificationRepository = emailVerificationRepository
    }
    
    func sendVerificaitonCode(to email: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        emailVerificationRepository.sendVerificationCode(to: email, completion: completion)
    }
    
    func verifyCode(for email: String, code: String, completion: @escaping (Result<Bool, any Error>) -> Void) {
        emailVerificationRepository.verifyCode(for: email, code: code, completion: completion)
    }
    
    func findAccount(by email: String, completion: @escaping (Result<String, any Error>) -> Void) {
        emailVerificationRepository.findAccount(by: email, completion: completion)
    }
}
