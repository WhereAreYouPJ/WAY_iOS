//
//  GetBookMarkFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import Foundation

protocol GetBookMarkFeedUseCase {
    func execute(page: Int32, completion: @escaping (Result<GenericResponse<GetBookMarkResponse>, Error>) -> Void)
}

class GetBookMarkFeedUseCaseImpl: GetBookMarkFeedUseCase {

    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }

    func execute(page: Int32, completion: @escaping (Result<GenericResponse<GetBookMarkResponse>, Error>) -> Void) {
        feedRepository.getBookMarkFeed(page: page, completion: completion)
    }
}
