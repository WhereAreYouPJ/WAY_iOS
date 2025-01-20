//
//  GetBookMarkFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import Foundation

protocol GetBookMarkFeedUseCase {
    func execute(page: Int32, completion: @escaping (Result<[BookMarkContent], Error>) -> Void)
}

class GetBookMarkFeedUseCaseImpl: GetBookMarkFeedUseCase {

    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }

    func execute(page: Int32, completion: @escaping (Result<[BookMarkContent], Error>) -> Void) {
        feedRepository.getBookMarkFeed(page: page) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data.content))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
