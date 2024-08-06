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
    
//    func fetchFeeds() {
//        // Fetch feeds from the API
//        // Update feeds array
//        self.feeds = [
//            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96조끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
//            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "장소2", title: "제목2", description: "내용2"),
//            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "장소3", title: "제목3", description: "내용3")
//        ]
//        onFeedsDataFetched?()
//    }
    
    func getFeeds() -> [Feed] {
        return Array(feeds.prefix(10))
    }
    
    func shouldShowMoreFeedsCell() -> Bool {
        return feeds.count > 10
    }
}
