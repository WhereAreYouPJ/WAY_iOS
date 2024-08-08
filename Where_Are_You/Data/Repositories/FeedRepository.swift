//
//  FeedRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Foundation

protocol FeedRepositoryProtocol {
    func createFeed(request: CreateFeedBody, completion: @escaping (Result<GenericResponse<FeedResponse>, Error>) -> Void)
    func updateFeed(request: UpdateFeedBody, completion: @escaping (Result<GenericResponse<FeedResponse>, Error>) -> Void)
}

class FeedRepository: FeedRepositoryProtocol {
    private let feedService: FeedServiceProtocol
    
    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }
    
    func createFeed(request: CreateFeedBody, completion: @escaping (Result<GenericResponse<FeedResponse>, any Error>) -> Void) {
        feedService.createFeed(request: request, completion: completion)
    }
    
    func updateFeed(request: UpdateFeedBody, completion: @escaping (Result<GenericResponse<FeedResponse>, any Error>) -> Void) {
        feedService.updateFeed(request: request, completion: completion)
    }
}
