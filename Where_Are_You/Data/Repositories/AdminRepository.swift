//
//  AdminRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/5/2025.
//

import Alamofire

protocol AdminRepositoryProtocol {
    func getAdminImage(completion: @escaping (Result<GenericResponse<[AdminResponse]>, Error>) -> Void)
    func getServerStatus(completion: @escaping (Result<Void, Error>) -> Void)
}

class AdminRepository: AdminRepositoryProtocol {
    private let adminService: AdminServiceProtocol
    
    init(adminService: AdminServiceProtocol) {
        self.adminService = adminService
    }
    
    func getAdminImage(completion: @escaping (Result<GenericResponse<[AdminResponse]>, any Error>) -> Void) {
        adminService.getAdminImage(completion: completion)
    }
    
    func getServerStatus(completion: @escaping (Result<Void, any Error>) -> Void) {
        adminService.getServerStatus(completion: completion)
    }
}
