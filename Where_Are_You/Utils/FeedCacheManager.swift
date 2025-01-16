//
//  FeedDataManager.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/12/2024.
//

import UIKit

class FeedCacheManager {
    static let shared = FeedCacheManager()
    private init() {}
    
    var cachedFeeds: [Feed] = []
}
