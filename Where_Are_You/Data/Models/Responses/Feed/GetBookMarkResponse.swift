//
//  GetBookMarkResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import Foundation

// MARK: - DataClass
struct GetBookMarkResponse: Codable {
    let totalElements, totalPages, size: Int
    let content: [BookMarkContent]
    let number: Int
    let sort: Sort
    let first, last: Bool
    let numberOfElements: Int
    let pageable: Pageable
    let empty: Bool
}

// MARK: - Content
struct BookMarkContent: Codable {
    let memberSeq: Int
    let feedSeq: Int
    let profileImageURL, startTime, location, title: String
    let bookMarkImageInfos: [FeedImageInfo]
    let bookMarkFriendInfos: [Info]
    let content: String
    let bookMark: Bool
}

// MARK: - BookMarkFriendInfo
struct BookMarkFriendInfo: Codable {
    let memberSeq: Int
    let userName, profileImageURL: String
}

// MARK: - Pageable
struct Pageable: Codable {
    let offset: Int
    let sort: Sort
    let paged: Bool
    let pageNumber, pageSize: Int
    let unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
    let empty, sorted, unsorted: Bool
}
