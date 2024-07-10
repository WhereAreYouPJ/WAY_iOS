//
//  Verif.swift
//  Where_Are_You
//
//  Created by 오정석 on 27/6/2024.
//

import Foundation

protocol VerifyCodeUseCase {
    func execute(identifier: String, code: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void)
}

class VerifyCodeUseCaseImpl: VerifyCodeUseCase {
    
    private let userRepository: AuthRepository
    
    init(userRepository: AuthRepository) {
        self.userRepository = userRepository
    }
    
    func execute(identifier: String, code: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepository.verifyEmailCode(identifier: identifier, code: code, type: type, completion: completion)
    }
}
