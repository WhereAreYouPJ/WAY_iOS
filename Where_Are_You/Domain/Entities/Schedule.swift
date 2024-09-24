//
//  Schedule.swift
//  Where_Are_You
//
//  Created by juhee on 09.08.24.
//

import Foundation

struct Schedule: Identifiable {
    let id = UUID()
    let scheduleSeq: Int
    let title: String
    let startTime: Date
    let endTime: Date
    let isAllday: Bool?
    let location: Location?
    let color: String
    let memo: String?
    let invitedMember: [Friend]?
}
