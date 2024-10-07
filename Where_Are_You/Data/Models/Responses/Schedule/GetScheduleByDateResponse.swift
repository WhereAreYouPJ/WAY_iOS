//
//  GetScheduleByDateResponse.swift
//  Where_Are_You
//
//  Created by juhee on 27.09.24.
//

import Foundation

struct ScheduleByDate: Codable {
    let scheduleSeq: Int
    let title: String
    let location: String?
    let color: String
    let startTime: String
    let endTime: String
    let group: String?
    let allDay: Bool?
}

typealias GetScheduleByDateResponse = [ScheduleByDate]
