//
//  GetScheduleResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/11/2024.
//

import Foundation

struct GetScheduleResponse: Codable {
    let title, startTime, endTime, location: String
    let streetName: String
    let x, y: Int
    let color, memo: String
    let allDay: Bool
    let memberInfos: [MemberInfos]
}

// MARK: - MemberInfo
struct MemberInfos: Codable {
    let memberSeq: Int
    let userName: String
    let isCreate: Bool
}
