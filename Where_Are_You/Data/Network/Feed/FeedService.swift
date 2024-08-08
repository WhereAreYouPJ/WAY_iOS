//
//  FeedService.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Alamofire
import Moya

protocol FeedServiceProtocol {
    func createFeed(request: CreateFeedBody, completion: @escaping (Result<GenericResponse<FeedResponse>, Error>) -> Void)
    func updateFeed(request: UpdateFeedBody, completion: @escaping (Result<GenericResponse<FeedResponse>, Error>) -> Void)
}

class FeedService: FeedServiceProtocol {
    
    // MARK: - Properties
    private var provider = MoyaProvider<FeedAPI>()
    
    init() {
        let tokenPlugin = AuthTokenPlugin(tokenClosure: {
            return UserDefaultsManager.shared.getAccessToken()
        })
        self.provider = MoyaProvider<FeedAPI>(plugins: [tokenPlugin])
    }
    
    func createFeed(request: CreateFeedBody, completion: @escaping (Result<GenericResponse<FeedResponse>, Error>) -> Void) {
        provider.request(.createFeed(request: request)) { [weak self] result in
            self?.handleResponse(result, completion: completion)
        }
    }
    
    func updateFeed(request: UpdateFeedBody, completion: @escaping (Result<GenericResponse<FeedResponse>, any Error>) -> Void) {
        provider.request(.updateFeed(request: request)) { [weak self] result in
            self?.handleResponse(result, completion: completion)
        }
    }
    
    // MARK: - Helpers

    private func handleResponse<T: Decodable>(_ result: Result<Response, MoyaError>, completion: @escaping (Result<T, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                let filteredResponse = try response.filterSuccessfulStatusCodes()
                let decodedData = try JSONDecoder().decode(T.self, from: filteredResponse.data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
