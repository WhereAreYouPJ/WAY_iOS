//
//  FeedTableViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import Foundation

class FeedTableViewModel {
    var onFeedsDataFetched: (() -> Void)?
    private var feeds: [String] = []
    
    func fetchFeeds() {
        // Fetch feeds from the API
        // Update feeds array
        self.feeds = [
            "여의도한강공원 96조 네번째 피크닉 다녀온 날",
            "피드 2",
            "피드 3"
        ]
        onFeedsDataFetched?()
    }
    
    func getFeeds() -> [String] {
        return feeds
    }
}
