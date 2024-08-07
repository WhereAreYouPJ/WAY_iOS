//
//  FindUserIDUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/7/2024.
//

import Foundation

protocol FindUserIDUseCase {
    func execute(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void)
}

class FindUserIDUseCaseImpl: FindUserIDUseCase {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
        authRepository.findUserID(email: email, code: code, completion: completion)
    }
}
