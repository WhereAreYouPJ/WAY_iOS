//
//  GetMonthlyScheduleBody.swift
//  Where_Are_You
//
//  Created by juhee on 12.09.24.
//

import Foundation

struct GetMonthlyScheduleBody: ParameterConvertible {
    let yearMonth: String
    let memberSeq: Int
}
