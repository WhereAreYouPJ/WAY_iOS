//
//  PostBookMarkFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import Foundation

protocol PostBookMarkFeedUseCase {
    func execute(request: BookMarkFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

class PostBookMarkFeedUseCaseImpl: PostBookMarkFeedUseCase {

    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    
    func execute(request: BookMarkFeedRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        feedRepository.postBookMarkFeed(request: request, completion: completion)
    }

}
