//
//  GetScheduleList.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/9/2024.
//

import Foundation

struct GetScheduleListResponse: Codable {
    let totalElements: Int
    let totalPages: Int
    let size: Int
    let content: [ScheduleContent]
    let number: Int
    let sort: SortInfo
    let numberOfElements: Int
    let pageable: PageableInfo
    let first: Bool
    let last: Bool
    let empty: Bool
}

struct ScheduleContent: Codable {
    let scheduleSeq: Int
    let startTime: String
    let title: String
    let feedExists: Bool
    let location: String
}

// MARK: - PageableInfo

struct PageableInfo: Codable {
    let offset: Int
    let pageNumber: Int
    let pageSize: Int
    let paged: Bool
    let unpaged: Bool
    let sort: SortInfo
}

// MARK: - SortInfo

struct SortInfo: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}
