//
//  UpdateFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Foundation

protocol UpdateFeedUseCase {
    func execute(request: UpdateFeedBody, completion: @escaping (Result<FeedResponse, Error>) -> Void)
}

class UpdateFeedUseCaseImpl: UpdateFeedUseCase {
    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }

    func execute(request: UpdateFeedBody, completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        feedRepository.updateFeed(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
