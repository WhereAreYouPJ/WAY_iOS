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
}
