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
    let content: [FeedContent]
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let pageable: Pageable
    let first, last, empty: Bool
}

// MARK: - Content
struct FeedContent: Codable {
    let scheduleInfo: ScheduleInfo // 일정 관련(디테일 박스 내용들)
    let scheduleFeedInfo: [ScheduleFeedInfo] // 피드 내용들)
    let scheduleFriendInfo: [Info] // 참가한 친구들 정보(디테일 박스에 들어갈 이미지, 디테일피드 상단에 들어갈 이름과 이미지)
}

// MARK: - ScheduleInfo
struct ScheduleInfo: Codable {
    let scheduleSeq: Int
    let startTime: String // 일정 날짜(디테일 박스)
    let location: String // 일정 장소(디테일 박스)
}

// MARK: - ScheduleFeedInfo
struct ScheduleFeedInfo: Codable {
    let memberInfo: Info // memberSeq 비교해서 사용자의 memberSeq와 맞는 내용을 넣는걸로 조건 걸기
    let feedInfo: FeedInfo // 피드 제목, 내용
    let feedImageInfos: [FeedImageInfo] // 피드 이미지
    let bookMarkInfo: Bool // 책갈피
}

// MARK: - Info
struct Info: Codable {
    let memberSeq: Int
    let userName: String
    let profileImage: String? // 프로필 이미지
}

// MARK: - FeedInfo
struct FeedInfo: Codable {
    let feedSeq: Int
    let title: String // 피드 제목
    let content: String // 피드 내용
}

// MARK: - FeedImageInfo
struct FeedImageInfo: Codable {
    let feedImageSeq: Int
    let feedImageURL: String
    let feedImageOrder: Int
}
