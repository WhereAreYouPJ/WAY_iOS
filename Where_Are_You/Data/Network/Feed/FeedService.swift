//
//  FeedService.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Alamofire
import Moya

protocol FeedServiceProtocol {
    func createFeed(request: CreateFeedBody, completion: @escaping (Result<Void, Error>) -> Void)
    func updateFeed(request: UpdateFeedBody, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    func createFeed(request: CreateFeedBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.createFeed(request: request)) { [weak self] result in
            self?.handleResponse(result, completion: completion)
        }
    }
    
    func updateFeed(request: UpdateFeedBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.updateFeed(request: request)) { [weak self] result in
            self?.handleResponse(result, completion: completion)
        }
    }
    
    // MARK: - Helpers
    private func handleResponse(_ result: Result<Moya.Response, MoyaError>, completion: @escaping (Result<Void, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                try response.filterSuccessfulStatusCodes()
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
