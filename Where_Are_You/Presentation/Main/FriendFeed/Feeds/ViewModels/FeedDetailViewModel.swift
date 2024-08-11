//
//  FeedDetailViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/8/2024.
//

import UIKit

class FeedDetailViewModel {
    var onFeedsDataFetched: (() -> Void)?
    var onFeedImageDataFetched: (() -> Void)?
    
    private var feeds: [Feed] = []
    private var feedImages: [UIImage] = []
    private var timer: Timer?
    private(set) var currentIndex = 0
    
    // MARK: - Helpers
    
    // 데이터 설정 메서드
    func setFeedImages(_ banners: [UIImage]) {
        self.feedImages = banners
        onFeedImageDataFetched?()
    }
    
    func getFeedImages() -> [UIImage] {
        return feedImages
    }
    
    // currentIndex를 업데이트하는 메서드 추가
    func updateCurrentIndex(to newIndex: Int) {
        currentIndex = newIndex
    }
    
    
    // 데이터 설정 메서드
    func setFeeds(_ feeds: [Feed]) {
        self.feeds = feeds
        onFeedsDataFetched?()
    }
    
    func getFeeds() -> [Feed] {
        return feeds
    }
    
    // MARK: - Selectors
    
    @objc private func scrollToNextPage() {
        guard !feedImages.isEmpty else { return }
        currentIndex = (currentIndex + 1) % feedImages.count
        let indexPath = IndexPath(item: currentIndex + 1, section: 0) // +1 to account for fake cells
        NotificationCenter.default.post(name: .scrollToFeedIndex, object: nil, userInfo: ["indexPath": indexPath])
    }
}

extension Notification.Name {
    static let scrollToFeedIndex = Notification.Name("scrollToFeedIndex")
}
