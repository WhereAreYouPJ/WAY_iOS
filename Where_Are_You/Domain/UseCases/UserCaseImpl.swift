//
//  UserCaseImpl.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class UserCaseImpl: UserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func login(email: String, password: String, comlpetion: @escaping (Result<User, any Error>) -> Void) {
        userRepository.login(email: email, password: password, completion: comlpetion)
    }
    
    func register(user: User, completion: @escaping (Result<User, any Error>) -> Void) {
        userRepository.register(user: user, completion: completion)
    }
    
    func findAccount(email: String, completion: @escaping (Result<String, any Error>) -> Void) {
        userRepository.findAccount(email: email, completion: completion)
    }
    
    func resetPassword(id: String, newPassword: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        userRepository.resetPassword(id: id, newPassword: newPassword, completion: completion)
    }
}
