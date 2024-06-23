//
//  UserRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Alamofire

class UserRepository: UserRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func signUp(request: SignUpRequestModel, completion: @escaping (Result<SignUpResponseModel, any Error>) -> Void) {
        apiService.signUp(request: request, completion: completion)
    }
    
    func checkUserIDAvailability(userID: String, completion: @escaping (Result<CheckAvailabilityResponseModel, any Error>) -> Void) {
        <#code#>
    }
    
    func checkEmailAvailability(email: String, completion: @escaping (Result<CheckAvailabilityResponseModel, any Error>) -> Void) {
        <#code#>
    }
    
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<EmailVerificationResponseModel, any Error>) -> Void) {
        <#code#>
    }
}
