//
//  GetServerStatusUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/5/2025.
//

import Foundation

protocol GetServerStatusUseCase {
    func execute(completion: @escaping (Result<Void, Error>) -> Void)
}

class GetServerStatusUseCaseImpl: GetServerStatusUseCase {
    private let adminRepository: AdminRepositoryProtocol
    
    init(adminRepository: AdminRepositoryProtocol) {
        self.adminRepository = adminRepository
    }
    
    func execute(completion: @escaping (Result<Void, any Error>) -> Void) {
        adminRepository.getServerStatus(completion: completion)
    }
}
