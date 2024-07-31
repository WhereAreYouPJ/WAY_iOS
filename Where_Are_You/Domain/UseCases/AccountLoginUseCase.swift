//
//  LoginUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/7/2024.
//

import Foundation

protocol AccountLoginUseCase {
    func execute(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AccountLoginUseCaseImpl: AccountLoginUseCase {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authRepository.login(email: email, password: password, completion: completion)
    }
}
