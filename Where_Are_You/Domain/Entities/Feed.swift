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
    let feedSeq: Int?
    let profileImage: String
    let startTime: String
    let location: String
    let title: String
    let content: String?
    var bookMarkInfo: Bool
    let scheduleFriendInfos: [Info]
    let feedImageInfos: [FeedImageInfo]
}

struct Feed {
    let feedSeq: Int?
    let memberSeq: Int?
    let startTime: String
    let profileImage: String
    let location: String
    let title: String
    let content: String?
    var bookMark: Bool
    let feedImage: String? // 홈화면에 뜨는 피드의 이미지 하나
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
            profileImage: firstScheduleFeedInfo.memberInfo.profileImageURL,
            location: scheduleInfo.location,
            title: firstScheduleFeedInfo.feedInfo.title,
            content: firstScheduleFeedInfo.feedInfo.content,
            bookMark: firstScheduleFeedInfo.bookMarkInfo,
            feedImage: nil,
            scheduleFriendInfos: scheduleFriendInfo,
            feedImageInfos: firstScheduleFeedInfo.feedImageInfos
        )
    }
}

extension BookMarkContent {
    func toFeeds() -> Feed {
        return Feed(
            feedSeq: nil, // BookMarkContent에는 feedSeq 없음
            memberSeq: memberSeq,
            startTime: startTime,
            profileImage: profileImage,
            location: location,
            title: title,
            content: content,
            bookMark: bookMark,
            feedImage: nil,
            scheduleFriendInfos: bookMarkFriendInfos,
            feedImageInfos: bookMarkImageInfos
        )
    }
}

extension HideFeedContent {
    func toFeeds() -> Feed {
        return Feed(
            feedSeq: nil, // BookMarkContent에는 feedSeq 없음
            memberSeq: memberSeq,
            startTime: startTime,
            profileImage: profileImage,
            location: location,
            title: title,
            content: content,
            bookMark: bookMark,
            feedImage: nil,
            scheduleFriendInfos: feedFriendInfos,
            feedImageInfos: hideFeedImageInfos
        )
    }
}
