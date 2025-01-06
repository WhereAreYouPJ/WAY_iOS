//
//  Feed.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit

struct HomeFeedContent {
    let profileImageURL: String
    let location: String
    let title: String
    let content: String?
    let feedImage: String?
}

struct MainFeedListContent {
    let feedSeq: Int
    let profileImageURL: String
    let startTime: String
    let location: String
    let title: String
    let content: String?
    var bookMarkInfo: Bool
    let scheduleFriendInfos: [Info]
    let feedImageInfos: [FeedImageInfo]
}

struct Feed {
    let feedSeq: Int
    let memberSeq: Int?
    let startTime: String
    let profileImageURL: String
    let location: String
    let title: String
    let content: String?
    var bookMark: Bool
    let scheduleFriendInfos: [Info]?
    let feedImageInfos: [FeedImageInfo]?
}

extension FeedContent {
    func toFeeds() -> Feed {
        guard let firstScheduleFeedInfo = scheduleFeedInfo.first else {
            fatalError("No ScheduleFeedInfo available.")
        }
        
        return Feed(
            feedSeq: firstScheduleFeedInfo.feedInfo.feedSeq,
            memberSeq: firstScheduleFeedInfo.memberInfo.memberSeq,
            startTime: scheduleInfo.startTime,
            profileImageURL: firstScheduleFeedInfo.memberInfo.profileImageURL,
            location: scheduleInfo.location,
            title: firstScheduleFeedInfo.feedInfo.title,
            content: firstScheduleFeedInfo.feedInfo.content,
            bookMark: firstScheduleFeedInfo.bookMarkInfo,
            scheduleFriendInfos: scheduleFriendInfo,
            feedImageInfos: firstScheduleFeedInfo.feedImageInfos
        )
    }
}

extension BookMarkContent {
    func toFeeds() -> Feed {
        return Feed(
            feedSeq: feedSeq,
            memberSeq: memberSeq,
            startTime: startTime,
            profileImageURL: profileImageURL,
            location: location,
            title: title,
            content: content,
            bookMark: bookMark,
            scheduleFriendInfos: bookMarkFriendInfos,
            feedImageInfos: bookMarkImageInfos
        )
    }
}

extension HideFeedContent {
    func toFeeds() -> Feed {
        return Feed(
            feedSeq: feedSeq,
            memberSeq: memberSeq,
            startTime: startTime,
            profileImageURL: profileImageURL,
            location: location,
            title: title,
            content: content,
            bookMark: bookMark,
            scheduleFriendInfos: feedFriendInfos,
            feedImageInfos: hideFeedImageInfos
        )
    }
}
