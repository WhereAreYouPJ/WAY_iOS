//
//  MonthScheduleResponse.swift
//  Where_Are_You
//
//  Created by juhee on 31.08.24.
//

import Foundation

struct ScheduleByMonth: Codable {
    let scheduleSeq: Int
    let title: String
    let startTime: String
    let endTime: String
    let location: String?
    let streetName: String?
    let x: Double?
    let y: Double?
    let color: String
    let memo: String?
    let allDay: Bool?
}

typealias GetScheduleByMonthResponse = [ScheduleByMonth]
