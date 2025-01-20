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
    func deleteFeed(request: DeleteFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func getFeedMain(completion: @escaping (Result<GenericResponse<GetFeedListResponse>, Error>) -> Void)
    func getFeedList(page: Int32, completion: @escaping (Result<GenericResponse<GetFeedListResponse>, Error>) -> Void)
    func getFeedDetails(scheduleSeq: Int, memberSeq: Int, completion: @escaping (Result<GenericResponse<FeedContent>, Error>) -> Void)

    func getBookMarkFeed(page: Int32, completion: @escaping (Result<GenericResponse<GetBookMarkResponse>, Error>) -> Void)
    func postBookMarkFeed(request: BookMarkFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteBookMarkFeed(request: BookMarkFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getHideFeed(page: Int32, completion: @escaping (Result<GenericResponse<GetHideFeedResponse>, Error>) -> Void)
    func postHideFeed(feedSeq: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteHideFeed(feedSeq: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

class FeedService: FeedServiceProtocol {
    // MARK: - Properties
    private var provider = MoyaProvider<FeedAPI>()
    
    private var memberSeq: Int {
        return UserDefaultsManager.shared.getMemberSeq()
    }
    
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
    
    func deleteFeed(request: DeleteFeedRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteFeed(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getFeedMain(completion: @escaping (Result<GenericResponse<GetFeedListResponse>, any Error>) -> Void) {
        provider.request(.getFeedMain(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getFeedList(page: Int32, completion: @escaping (Result<GenericResponse<GetFeedListResponse>, Error>) -> Void) {
        provider.request(.getFeedList(memberSeq: memberSeq, page: page)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getFeedDetails(scheduleSeq: Int, memberSeq: Int, completion: @escaping (Result<GenericResponse<FeedContent>, any Error>) -> Void) {
        provider.request(.getFeedDetails(memberSeq: memberSeq, scheduleSeq: scheduleSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getBookMarkFeed(page: Int32, completion: @escaping (Result<GenericResponse<GetBookMarkResponse>, any Error>) -> Void) {
        provider.request(.getBookMarkFeed(memberSeq: memberSeq, page: page)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postBookMarkFeed(request: BookMarkFeedRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postBookMarkFeed(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func deleteBookMarkFeed(request: BookMarkFeedRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteBookMarkFeed(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getHideFeed(page: Int32, completion: @escaping (Result<GenericResponse<GetHideFeedResponse>, any Error>) -> Void) {
        provider.request(.getHideFeed(memberSeq: memberSeq, page: page)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postHideFeed(feedSeq: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.postHideFeed(feedSeq: feedSeq, memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func deleteHideFeed(feedSeq: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.deleteHideFeed(feedSeq: feedSeq, memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
