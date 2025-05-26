//
//  AdminService.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/5/2025.
//

import Foundation
import Moya

protocol AdminServiceProtocol {
    func getAdminImage(completion: @escaping (Result<GenericResponse<AdminResponse>, Error>) -> Void)
    func getServerStatus(completion: @escaping (Result<Void, Error>) -> Void)
}

class AdminService: AdminServiceProtocol {
    // MARK: - Properties
    private var provider = MoyaProvider<AdminAPI>()
    
    private var memberSeq: Int {
        return UserDefaultsManager.shared.getMemberSeq()
    }
    
    init() {
        let tokenPlugin = AuthTokenPlugin(tokenClosure: {
            return UserDefaultsManager.shared.getAccessToken()
        })
        self.provider = MoyaProvider<AdminAPI>(plugins: [tokenPlugin])
    }

    // MARK: - APIService
    func getAdminImage(completion: @escaping (Result<GenericResponse<AdminResponse>, Error>) -> Void) {
        provider.request(.getAdminImage(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getServerStatus(completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.getServerStatus) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
