//
//  Verif.swift
//  Where_Are_You
//
//  Created by 오정석 on 27/6/2024.
//

import Foundation

protocol VerifyEmailCodeUseCase {
    func execute(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
    func execute(userId: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
    
}

class VerifyEmailCodeUseCaseImpl: VerifyEmailCodeUseCase {
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.verifyEmailCode(email: email, code: code, completion: completion)
    }
    
    func execute(userId: String, code: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        userRepository.verifyEmailCode(userId: userId, code: code, completion: completion)
    }
}
