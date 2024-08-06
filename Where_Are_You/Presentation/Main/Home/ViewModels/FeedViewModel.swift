//
//  FeedTableViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import Foundation
import UIKit

class FeedViewModel {
    var onFeedsDataFetched: (() -> Void)?
    private var feeds: [Feed] = []
    
    // 데이터 설정 메서드
    func setFeeds(_ feeds: [Feed]) {
        self.feeds = feeds
        onFeedsDataFetched?()
    }
    
    func getFeeds() -> [Feed] {
        return Array(feeds.prefix(10))
    }
    
    func shouldShowMoreFeedsCell() -> Bool {
        return feeds.count > 10
    }
}
