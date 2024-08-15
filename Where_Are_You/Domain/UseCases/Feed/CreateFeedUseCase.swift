//
//  CreateFeedUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

protocol CreateFeedUseCase {
    func execute(request: CreateFeedBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class CreateFeedUseCaseImpl: CreateFeedUseCase {
    private let feedRepository: FeedRepositoryProtocol

    init(feedRepository: FeedRepositoryProtocol) {
        self.feedRepository = feedRepository
    }

    // TODO: request를 사용자가 입력한 데이터를 여기서 가공하게 수정하기
    func execute(request: CreateFeedBody, completion: @escaping (Result<Void, Error>) -> Void) {
        feedRepository.createFeed(request: request, completion: completion)
    }
}
