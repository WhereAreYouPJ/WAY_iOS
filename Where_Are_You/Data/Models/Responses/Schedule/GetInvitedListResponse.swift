//
//  GetInvitedListResponse.swift
//  Where_Are_You
//
//  Created by juhee on 12.01.25.
//

import Foundation

struct GetInvitedList: Codable {
    let scheduleSeq: Int
    let startTime: String
    let title: String
    let location: String
    let dDay: Int
}

typealias GetInvitedListResponse = [GetInvitedList]
