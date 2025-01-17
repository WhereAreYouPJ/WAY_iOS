//
//  GetFeedMainUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/1/2025.
//

import Foundation

protocol GetFeedMainUseCase {
    func execute(completion: @escaping (Result<[FeedContent], Error>) -> Void)
}

class GetFeedMainUseCaseImpl: GetFeedMainUseCase {
    private let feedRepository: FeedRepositoryProtocol
    
    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    
    func execute(completion: @escaping (Result<[FeedContent], Error>) -> Void) {
        feedRepository.getFeedMain { result in
            switch result {
            case .success(let response):
                completion(.success(response.data.content))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
