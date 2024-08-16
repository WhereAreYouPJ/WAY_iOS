//
//  Schedule.swift
//  Where_Are_You
//
//  Created by juhee on 09.08.24.
//

import Foundation

struct Schedule: Codable {
    var title: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var location: String = ""
    var streetName: String = ""
    var x: Double = 0
    var y: Double = 0
    var color: String = ""
    var memo: String = ""
    var invitedMemberSeqs: [String] = []
    var createMemberSeq: Int = 0
}
