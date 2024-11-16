//
//  GetFeedListUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol GetFeedListUseCase {
    func execute(page: Int32, completion: @escaping (Result<GetFeedListResponse, Error>) -> Void)
    
}

class GetFeedListUseCaseImpl: GetFeedListUseCase {
    private let feedRepository: FeedRepositoryProtocol
    
    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    
    func execute(page: Int32, completion: @escaping (Result<GetFeedListResponse, any Error>) -> Void) {
        feedRepository.getFeedList(page: page) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
