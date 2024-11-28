//
//  Feed.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit

struct HomeFeedContent {
    let profileImage: String
    let location: String
    let title: String
    let content: String?
    let feedImage: String?
}

struct MainFeedListContent {
    let profileImage: String
    let startTime: String
    let location: String
    let title: String
    let content: String?
    let scheduleFriendInfos: [Info]
    let feedImageInfos: [FeedImageInfo]
}
