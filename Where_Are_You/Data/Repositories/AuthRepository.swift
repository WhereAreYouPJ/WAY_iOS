//
//  UserRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Alamofire

protocol AuthRepositoryProtocol {
    func signUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void)
    func resetPassword(email: String, password: String, checkPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func checkEmailAvailability(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func sendVerificationCode(identifier: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyEmailCode(identifier: String, code: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void)
    func findUserID(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void)
    
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AuthRepository: AuthRepositoryProtocol {
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func signUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.signUp(request: request, completion: completion)
    }
    
    func resetPassword(email: String, password: String, checkPassword: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        authService.resetPassword(email: email, password: password, checkPassword: checkPassword, completion: completion)
    }
    
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.checkUserIDAvailability(userId: userId, completion: completion)
    }
    
    func checkEmailAvailability(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.checkEmailAvailability(email: email, completion: completion)
    }
    
    func sendVerificationCode(identifier: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.sendVerificationCode(identifier: identifier, type: type, completion: completion)
    }
    
    func verifyEmailCode(identifier: String, code: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.verifyEmailCode(identifier: identifier, code: code, type: type, completion: completion)
    }
    
    func findUserID(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
        authService.findUserID(email: email, code: code, completion: completion)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        authService.login(email: email, password: password, completion: completion)
    }
    
}
