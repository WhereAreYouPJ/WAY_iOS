//
//  UserRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

//protocol UserRepository {
//    func login(userID: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
//    func register(user: User, completion: @escaping (Result<User, Error>) -> Void)
//    func findAccount(email: String, completion: @escaping (Result<String, Error>) -> Void)
//    func resetPassword(email: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
//}

protocol UserRepositoryProtocol {
    func checkDuplicateID(id: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class UserRepository: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func checkDuplicateID(userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        apiService.checkDuplicateID(userID: userID, completion: completion)
    }
}

