//
//  UserRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Alamofire

protocol UserRepositoryProtocol {
    func signUp(request: User, completion: @escaping (Result<Void, Error>) -> Void)
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<GenericResponse<CheckDuplicateUserID>, Error>) -> Void)
    func checkEmailAvailability(email: String, completion: @escaping (Result<GenericResponse<CheckDuplicateEmail>, Error>) -> Void)
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class UserRepository: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func signUp(request: User, completion: @escaping (Result<Void, any Error>) -> Void) {
        apiService.signUp(request: request, completion: completion)
    }
    
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<GenericResponse<CheckDuplicateUserID>, any Error>) -> Void) {
        apiService.checkUserIDAvailability(userId: userId, completion: completion)
    }
    
    func checkEmailAvailability(email: String, completion: @escaping (Result<GenericResponse<CheckDuplicateEmail>, any Error>) -> Void) {
        apiService.checkEmailAvailability(email: email, completion: completion)
    }
    
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        apiService.sendEmailVerificationCode(email: email, completion: completion)
    }
    
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, any Error>) -> Void) {
            apiService.verifyEmailCode(email: email, code: code, completion: completion)
        }
}
