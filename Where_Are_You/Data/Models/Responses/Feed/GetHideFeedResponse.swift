//
//  GetHideFeedResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

// MARK: - GetHideFeedResponse
struct GetHideFeedResponse: Codable {
    let totalElements, totalPages, size: Int
    let content: [HideFeedContent]
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let pageable: Pageable
    let first, last, empty: Bool
}

// MARK: - HideFeedContent
struct HideFeedContent: Codable {
    let profileImage, startTime, location, title: String
    let hideFeedImageInfos: [HideFeedImageInfo]
    let content: String
    let bookMark: Bool
    let feedFriendInfos: [FeedFriendInfo]
}

// MARK: - FeedFriendInfo
struct FeedFriendInfo: Codable {
    let memberSeq: Int
    let userName, profileImage: String
}

// MARK: - HideFeedImageInfo
struct HideFeedImageInfo: Codable {
    let feedImageSeq: Int
    let feedImageURL: String
    let feedImageOrder: Int
}