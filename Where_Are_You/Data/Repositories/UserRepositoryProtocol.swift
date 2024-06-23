//
//  UserRepositoryProtocol.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol UserRepositoryProtocol {
    func signUp(request: SignUpRequestModel, completion: @escaping (Result<SignUpResponseModel, Error>) -> Void)
    func checkUserIDAvailability(userID: String, completion: @escaping (Result<CheckAvailabilityResponseModel, Error>) -> Void)
    func checkEmailAvailability(email: String, completion: @escaping (Result<CheckAvailabilityResponseModel, Error>) -> Void)
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<EmailVerificationResponseModel, Error>) -> Void)
    
}
