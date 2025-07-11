//
//  GetInvitedListResponse.swift
//  Where_Are_You
//
//  Created by juhee on 12.01.25.
//

import Foundation

struct GetInvitedList: Codable {
    let scheduleSeq: Int
    let createdAt: String
    let startTime: String
    let title: String
    let location: String
    let dDay: Int
    let creatorName: String
}

typealias GetInvitedListResponse = [GetInvitedList]
