//
//  SignUpUseCaseImpl.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

class SignUpUseCaseImpl: SignUpUseCase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(request: SignUpRequestModel, completion: @escaping (Result<SignUpResponseModel, any Error>) -> Void) {
        userRepository.signUp(request: request, completion: completion)
    }
}
