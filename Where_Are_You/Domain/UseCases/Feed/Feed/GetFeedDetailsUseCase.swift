//
//  GetFeedDetailsUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol GetFeedDetailsUseCase {
    func execute(scheduleSeq: Int, completion: @escaping (Result<FeedContent, Error>) -> Void)
}

class GetFeedDetailsUseCaseImpl: GetFeedDetailsUseCase {
    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    
    func execute(scheduleSeq: Int, completion: @escaping (Result<FeedContent, any Error>) -> Void) {
        feedRepository.getFeedDetails(scheduleSeq: scheduleSeq) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
