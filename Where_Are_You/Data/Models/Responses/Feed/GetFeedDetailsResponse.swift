//
//  GetFeedDetailsResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

// MARK: - DataClass
struct GetFeedDetailsResponse: Codable {
    let scheduleInfo: ScheduleInfo
    let scheduleFeedInfo: [ScheduleFeedInfo]
    let scheduleFriendInfo: [Info]
}

// MARK: - ScheduleFeedInfo
struct ScheduleFeedInfo: Codable {
    let memberInfo: Info
    let feedInfo: FeedInfo
    let feedImageInfos: [FeedImageInfo]
    let bookMarkInfo: Bool
}

