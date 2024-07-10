//
//  LoginUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/7/2024.
//

import Foundation

protocol AccountLoginUseCase {
    func execute(userId: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AccountLoginUseCaseImpl: AccountLoginUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(userId: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.login(userId: userId, password: password, completion: completion)
    }
}
