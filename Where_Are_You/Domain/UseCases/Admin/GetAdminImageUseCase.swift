//
//  GetAdminImageUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/5/2025.
//

import Foundation

protocol GetAdminImageUseCase {
    func execute(completion: @escaping (Result<[AdminResponse], Error>) -> Void)
}

class GetAdminImageUseCaseImpl: GetAdminImageUseCase {
    private let adminRepository: AdminRepositoryProtocol
    
    init(adminRepository: AdminRepositoryProtocol) {
        self.adminRepository = adminRepository
    }
    
    func execute(completion: @escaping (Result<[AdminResponse], any Error>) -> Void) {
        adminRepository.getAdminImage { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
