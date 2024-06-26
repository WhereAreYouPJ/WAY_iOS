//
//  CheckUserIDAvailabilityUseCaseImpl.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

class CheckUserIDAvailabilityUseCaseImpl: CheckUserIDAvailabilityUseCase {
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(userID: String, completion: @escaping (Result<Bool, any Error>) -> Void) {
        userRepository.checkUserIDAvailability(userID: userID) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data.isAvailable))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
