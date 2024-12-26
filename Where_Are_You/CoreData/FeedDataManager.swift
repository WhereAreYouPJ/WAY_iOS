//
//  FeedDataManager.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/12/2024.
//

import Kingfisher
import UIKit
import Foundation

class FeedDataManager {
    static let shared = FeedDataManager()
    
    private var feedCache: [Int: [MainFeedListContent]] = [:] // scheduleSeq -> [피드]
    private var imageCache: [String: UIImage] = [:]           // imageURL -> UIImage
    private var currentPage: [Int: Int32] = [:]                // scheduleSeq -> currentPage
    private var isLoading: [Int: Bool] = [:]                 // scheduleSeq -> isLoading
    
    private init() {}
    
    // MARK: - Fetch Feeds
    func fetchFeeds(for scheduleSeq: Int, completion: @escaping ([MainFeedListContent]?) -> Void) {
        guard isLoading[scheduleSeq] != true else { return }
        isLoading[scheduleSeq] = true
        
        let page = currentPage[scheduleSeq] ?? 0
        let useCase = GetFeedListUseCaseImpl(feedRepository: FeedRepository(feedService: FeedService()))
        
        useCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading[scheduleSeq] = false
            
            switch result {
            case .success(let newFeeds):
                let convertedFeeds = newFeeds.compactMap { feedContent -> MainFeedListContent? in
                    guard let scheduleFeedInfo = feedContent.scheduleFeedInfo.first else { return nil }
                    return MainFeedListContent(
                        feedSeq: scheduleFeedInfo.feedInfo.feedSeq,
                        profileImageURL: scheduleFeedInfo.memberInfo.profileImageURL,
                        startTime: feedContent.scheduleInfo.startTime,
                        location: feedContent.scheduleInfo.location,
                        title: scheduleFeedInfo.feedInfo.title,
                        content: scheduleFeedInfo.feedInfo.content,
                        bookMarkInfo: scheduleFeedInfo.bookMarkInfo,
                        scheduleFriendInfos: feedContent.scheduleFriendInfo,
                        feedImageInfos: scheduleFeedInfo.feedImageInfos
                    )
                }
                feedCache[scheduleSeq] = (feedCache[scheduleSeq] ?? []) + convertedFeeds
                self.currentPage[scheduleSeq] = page + 1
                completion(self.feedCache[scheduleSeq])
            case .failure:
                completion(nil)
            }
        }
    }
    
    // MARK: - Fetch Images
    func fetchImages(for imageUrls: [String], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for url in imageUrls {
            if let cachedImage = imageCache[url] {
                images.append(cachedImage)
                continue
            }
            
            guard let imageURL = URL(string: url) else { continue }
            group.enter()
            KingfisherManager.shared.retrieveImage(with: imageURL) { [weak self] result in
                defer { group.leave() }
                switch result {
                case .success(let imageResult):
                    self?.imageCache[url] = imageResult.image
                    images.append(imageResult.image)
                case .failure(let error):
                    print("이미지 로드 실패: \(error.localizedDescription)")
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    // MARK: - Clear Cache
    func clearCache() {
        feedCache.removeAll()
        imageCache.removeAll()
        currentPage.removeAll()
        isLoading.removeAll()
    }
}
