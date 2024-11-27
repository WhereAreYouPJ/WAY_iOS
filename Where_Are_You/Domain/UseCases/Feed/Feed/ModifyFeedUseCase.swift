//
//  UpdateFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

protocol UpdateFeedUseCase {
    func execute(request: ModifyFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void)
}

class UpdateFeedUseCaseImpl: UpdateFeedUseCase {
    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }

    func execute(request: ModifyFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void) {
        feedRepository.putFeed(request: request, images: images, completion: completion)
    }
}
