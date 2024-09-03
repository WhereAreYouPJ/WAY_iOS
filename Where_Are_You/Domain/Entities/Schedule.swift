//
//  Schedule.swift
//  Where_Are_You
//
//  Created by juhee on 09.08.24.
//

import Foundation

struct Schedule: Identifiable {
    var id = UUID()
    var title: String
    var startTime: Date?
    var endTime: Date?
    var place: Place?
    var color: String?
    var memo: String?
    var invitedMember: [Friend]?
}
