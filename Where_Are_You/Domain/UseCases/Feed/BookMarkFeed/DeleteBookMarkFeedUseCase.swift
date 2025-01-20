//
//  DeleteBookMarkFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import Foundation

protocol DeleteBookMarkFeedUseCase {
    func execute(request: BookMarkFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteBookMarkFeedUseCaseImpl: DeleteBookMarkFeedUseCase {

    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    
    func execute(request: BookMarkFeedRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        feedRepository.deleteBookMarkFeed(request: request, completion: completion)
    }

}
