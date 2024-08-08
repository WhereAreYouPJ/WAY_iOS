//
//  CreateFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Foundation

protocol CreateFeedUseCase {
    func execute(request: CreateFeedBody, completion: @escaping (Result<FeedResponse, Error>) -> Void)
}

class CreateFeedUseCaseImpl: CreateFeedUseCase {
    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }

    func execute(request: CreateFeedBody, completion: @escaping (Result<FeedResponse, Error>) -> Void) {
        feedRepository.createFeed(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
