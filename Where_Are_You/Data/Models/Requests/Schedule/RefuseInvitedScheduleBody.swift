//
//  DeleteInvitedScheduleBody.swift
//  Where_Are_You
//
//  Created by juhee on 12.01.25.
//

import Foundation

struct RefuseInvitedScheduleBody: ParameterConvertible {
    let memberSeq: Int
    let scheduleSeq: Int
}
