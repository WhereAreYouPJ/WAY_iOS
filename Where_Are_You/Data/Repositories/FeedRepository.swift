//
//  FeedRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

protocol FeedRepositoryProtocol {
    func createFeed(request: SaveFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void)
    func updateFeed(request: ModifyFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void)
}

class FeedRepository: FeedRepositoryProtocol {
    private let feedService: FeedServiceProtocol
    
    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }
    
    func createFeed(request: SaveFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void) {
        feedService.createFeed(request: request, images: images, completion: completion)
    }
    
    func updateFeed(request: ModifyFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void) {
        feedService.updateFeed(request: request, images: images, completion: completion)
    }
}
