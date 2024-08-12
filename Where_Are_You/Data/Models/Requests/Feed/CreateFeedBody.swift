//
//  CreateFeedBody.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import Foundation

struct CreateFeedBody: ParameterConvertible {
    let scheduleSeq: Int
    let creatorSeq: Int
    let title: String
    let content: String
    var images: [String]
}