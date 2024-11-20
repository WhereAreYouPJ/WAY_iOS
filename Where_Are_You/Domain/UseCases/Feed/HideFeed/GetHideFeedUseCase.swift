//
//  GetHideFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol GetHideFeedUseCase {
    func execute(page: Int32, completion: @escaping (Result<[HideFeedContent], Error>) -> Void)
}

class GetHideFeedUseCaseImpl: GetHideFeedUseCase {

    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    
    func execute(page: Int32, completion: @escaping (Result<[HideFeedContent], Error>) -> Void) {
        feedRepository.getHideFeed(page: page) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data.content))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
