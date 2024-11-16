//
//  GetHideFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol GetHideFeedUseCase {
    func execute(page: Int32, completion: @escaping (Result<GenericResponse<GetHideFeedResponse>, Error>) -> Void)
}

class GetHideFeedUseCaseImpl: GetHideFeedUseCase {

    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }
    
    func execute(page: Int32, completion: @escaping (Result<GenericResponse<GetHideFeedResponse>, Error>) -> Void) {
        feedRepository.getHideFeed(page: page, completion: completion)
    }
}
