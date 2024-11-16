//
//  GetFeedListResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation
// MARK: - DataClass
struct GetFeedListResponse: Codable {
    let totalElements, totalPages, size: Int
    let content: [Content]
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let pageable: Pageable
    let first, last, empty: Bool
}

// MARK: - Content
struct Content: Codable {
    let scheduleInfo: ScheduleInfo
    let scheduleFeedInfo: [ScheduleFeedInfo]
    let scheduleFriendInfo: [Info]
}

// MARK: - FeedImageInfo
struct FeedImageInfo: Codable {
    let feedImageSeq: Int
    let feedImageURL: String
    let feedImageOrder: Int
}

// MARK: - FeedInfo
struct FeedInfo: Codable {
    let feedSeq: Int
    let title, content: String
}

// MARK: - Info
struct Info: Codable {
    let memberSeq: Int
    let userName, profileImage: String
}

// MARK: - ScheduleInfo
struct ScheduleInfo: Codable {
    let scheduleSeq: Int
    let startTime, location: String
}
