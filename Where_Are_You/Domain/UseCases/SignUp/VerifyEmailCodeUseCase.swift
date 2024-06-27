//
//  Verif.swift
//  Where_Are_You
//
//  Created by 오정석 on 27/6/2024.
//

import Foundation

protocol VerifyEmailCodeUseCase {
    func execute(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)

}

class VerifyEmailCodeUseCaseImpl: VerifyEmailCodeUseCase {
    private let repository: UserRepository
        
        init(repository: UserRepository) {
            self.repository = repository
        }
        
        func execute(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
            repository.verifyEmailCode(email: email, code: code, completion: completion)
        }
}
