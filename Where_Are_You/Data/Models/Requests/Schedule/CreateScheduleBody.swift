//
//  CreateScheduleBody.swift
//  Where_Are_You
//
//  Created by juhee on 09.08.24.
//

import Foundation

struct CreateScheduleBody: ParameterConvertible {
    let title: String?
    let startTime: String?
    let endTime: String?
    let location: String?
    let streetName: String?
    let x: Double?
    let y: Double?
    let color: String?
    let memo: String?
    let invitedMemberSeqs: [Int]?
    let createMemberSeq: Int?
}
