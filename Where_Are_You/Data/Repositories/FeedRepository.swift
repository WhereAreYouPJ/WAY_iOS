//
//  FeedRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

protocol FeedRepositoryProtocol {
    func postFeed(request: SaveFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void)
    func putFeed(request: ModifyFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteFeed(request: DeleteFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func getFeedList(page: Int32, completion: @escaping (Result<GenericResponse<GetFeedListResponse>, Error>) -> Void)
    func getFeedDetails(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetFeedDetailsResponse>, Error>) -> Void)
    
    
    func getBookMarkFeed(page: Int32, completion: @escaping (Result<GenericResponse<GetBookMarkResponse>, Error>) -> Void)
    func postBookMarkFeed(request: BookMarkFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteBookMarkFeed(request: BookMarkFeedRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

class FeedRepository: FeedRepositoryProtocol {
    private let feedService: FeedServiceProtocol
    
    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }
    
    // MARK: - Feed

    func postFeed(request: SaveFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void) {
        feedService.postFeed(request: request, images: images, completion: completion)
    }
    
    func putFeed(request: ModifyFeedRequest, images: [UIImage]?, completion: @escaping (Result<Void, Error>) -> Void) {
        feedService.putFeed(request: request, images: images, completion: completion)
    }
    
    func deleteFeed(request: DeleteFeedRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        feedService.deleteFeed(request: request, completion: completion)
    }
    
    func getFeedList(page: Int32, completion: @escaping (Result<GenericResponse<GetFeedListResponse>, any Error>) -> Void) {
        feedService.getFeedList(page: page, completion: completion)
    }
    
    func getFeedDetails(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetFeedDetailsResponse>, any Error>) -> Void) {
        feedService.getFeedDetails(scheduleSeq: scheduleSeq, completion: completion)
    }
    
    // MARK: - BookMarkFeed

    func getBookMarkFeed(page: Int32, completion: @escaping (Result<GenericResponse<GetBookMarkResponse>, any Error>) -> Void) {
        feedService.getBookMarkFeed(page: page, completion: completion)
    }
    
    func postBookMarkFeed(request: BookMarkFeedRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        feedService.postBookMarkFeed(request: request, completion: completion)
    }
    
    func deleteBookMarkFeed(request: BookMarkFeedRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        feedService.deleteBookMarkFeed(request: request, completion: completion)
    }
}
