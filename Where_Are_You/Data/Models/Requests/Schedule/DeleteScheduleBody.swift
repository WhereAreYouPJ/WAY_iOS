//
//  DeleteScheduleBody.swift
//  Where_Are_You
//
//  Created by juhee on 09.10.24.
//

import Foundation

struct DeleteScheduleBody: ParameterConvertible {
    let scheduleSeq: Int
    let memberSeq: Int
}
