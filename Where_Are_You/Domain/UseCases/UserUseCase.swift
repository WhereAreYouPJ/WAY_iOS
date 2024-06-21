//
//  UserUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

protocol UserUseCase {
    func login(userID: String, password: String, comlpetion: @escaping(Result<User, Error>) -> Void)
    func register(user: User, completion: @escaping (Result<User, Error>) -> Void)
    func findAccount(email: String, completion: @escaping (Result<String, Error>) -> Void)
    func resetPassword(email: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
    func checkDuplicateID(id: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

class UserCaseImpl: UserUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func login(userID: String, password: String, comlpetion: @escaping (Result<User, any Error>) -> Void) {
//        userRepository.login(userID: userID, password: password, completion: comlpetion)
    }
    
    func register(user: User, completion: @escaping (Result<User, any Error>) -> Void) {
//        userRepository.register(user: user, completion: completion)
    }
    
    func findAccount(email: String, completion: @escaping (Result<String, any Error>) -> Void) {
//        userRepository.findAccount(email: email, completion: completion)
    }
    
    func resetPassword(email: String, newPassword: String, completion: @escaping (Result<Void, any Error>) -> Void) {
//        userRepository.resetPassword(email: email, newPassword: newPassword, completion: completion)
    }
    
    func checkDuplicateID(id: String, completion: @escaping (Result<Bool, any Error>) -> Void) {
        
    }
}
