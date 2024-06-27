//
//  SendEmailVerificationCodeUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol SendEmailVerificationCodeUseCase {
    func execute(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class SendEmailVerificationCodeUseCaseImpl: SendEmailVerificationCodeUseCase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        userRepository.sendEmailVerificationCode(email: email) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
