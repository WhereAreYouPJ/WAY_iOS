//
//  PostHideFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol PostHideFeedUseCase {
    func execute(feedSeq: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

class PostHideFeedUseCaseImpl: PostHideFeedUseCase {

    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    
    func execute(feedSeq: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        feedRepository.postHideFeed(feedSeq: feedSeq, completion: completion)
    }

}
