//
//  MonthScheduleResponse.swift
//  Where_Are_You
//
//  Created by juhee on 31.08.24.
//

import Foundation

struct MonthScheduleResponse: Codable {
    let scheduleSeq: Int
    let title: String
    let startTime: String
    let endTime: String
    let location: String
    let streetName: String
    let x: Double
    let y: Double
    let memo: String
}
