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
    var title: String
    var startTime: Date
    var endTime: Date
    var isAllday: Bool?
    var location: Location?
    var color: String
    var memo: String?
    var invitedMember: [Friend]?
}
