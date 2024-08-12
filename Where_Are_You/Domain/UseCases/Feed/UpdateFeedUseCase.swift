//
//  UpdateFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

protocol UpdateFeedUseCase {
    func execute(request: UpdateFeedBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class UpdateFeedUseCaseImpl: UpdateFeedUseCase {
    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }

    func execute(request: UpdateFeedBody, completion: @escaping (Result<Void, Error>) -> Void) {
        feedRepository.updateFeed(request: request, completion: completion)
    }
}
