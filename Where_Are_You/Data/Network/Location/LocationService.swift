//
//  LocationService.swift
//  Where_Are_You
//
//  Created by 오정석 on 13/10/2024.
//

import Alamofire
import Moya

// MARK: - LocationServiceProtocol

protocol LocationServiceProtocol {
    func getLocation(memberSeq: Int, completion: @escaping (Result<GenericResponse<GetFavLocationResponse>, Error>) -> Void)
    func putLocation(request: PutFavoriteLocationRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func postLocation(request: PostFavoriteLocationBody, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteLocation(request: DeleteFavoriteLocationBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class LocationService: LocationServiceProtocol {
    private var provider = MoyaProvider<LocationAPI>()
    
    private var memberSeq: Int {
        return UserDefaultsManager.shared.getMemberSeq()
    }
    
    init() {
        let tokenPlugin = AuthTokenPlugin(tokenClosure: {
            return UserDefaultsManager.shared.getAccessToken()
        })
        self.provider = MoyaProvider<LocationAPI>(plugins: [tokenPlugin])
    }

    // MARK: - APIService
    func getLocation(memberSeq: Int, completion: @escaping (Result<GenericResponse<GetFavLocationResponse>, any Error>) -> Void) {
        provider.request(.getLocation(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func putLocation(request: PutFavoriteLocationRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.putLocation(memberSeq: memberSeq, request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postLocation(request: PostFavoriteLocationBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postLocation(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func deleteLocation(request: DeleteFavoriteLocationBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteLocation(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
