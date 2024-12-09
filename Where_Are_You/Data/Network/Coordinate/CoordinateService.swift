//
//  CoordinateService.swift
//  Where_Are_You
//
//  Created by juhee on 09.12.24.
//

import Alamofire
import Moya

protocol CoordinateServiceProtocol {
    func getCoordinate(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetCoordinateResponse>, Error>) -> Void)
    func postCoordinate(request: PostCoordinateBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class CoordinateService: CoordinateServiceProtocol {
    private var provider = MoyaProvider<CoordinateAPI>()
    
    private var memberSeq: Int {
        return UserDefaultsManager.shared.getMemberSeq()
    }
    
    init() {
        let tokenPlugin = AuthTokenPlugin(tokenClosure: {
            return UserDefaultsManager.shared.getAccessToken()
        })
        self.provider = MoyaProvider<CoordinateAPI>(plugins: [tokenPlugin])
    }

    func getCoordinate(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetCoordinateResponse>, any Error>) -> Void) {
        provider.request(.getCoordinate(memberSeq: memberSeq, scheduleSeq: scheduleSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postCoordinate(request: PostCoordinateBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postCoordinate(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
