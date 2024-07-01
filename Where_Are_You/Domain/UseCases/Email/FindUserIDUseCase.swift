//
//  FindUserIDUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/7/2024.
//

import Foundation

protocol FindUserIDUseCase {
    func execute(email: String, completion: @escaping (Result<String, Error>) -> Void)
}

class FindUserIDUseCaseImpl: FindUserIDUseCase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        userRepository.findUserID(email: email, completion: completion)
    }
}
