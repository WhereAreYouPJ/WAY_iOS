//
//  DeleteFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol DeleteFeedUseCase {
    func execute(request: DeleteFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteFeedUseCaseImpl: DeleteFeedUseCase {
    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    func execute(request: DeleteFeedRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        feedRepository.deleteFeed(request: request, completion: completion)
    }
}
