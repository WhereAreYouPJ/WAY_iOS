//
//  FeedService.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Alamofire
import Moya

protocol FeedServiceProtocol {
    func postFeed(request: SaveFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void)
    func putFeed(request: ModifyFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void)
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
    
    func postFeed(request: SaveFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.postFeed(request: request, images: images)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func putFeed(request: ModifyFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.putFeed(request: request, images: images)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
