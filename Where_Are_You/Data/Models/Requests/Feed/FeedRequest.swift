//
//  CreateFeedBody.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

struct SaveFeedRequest: Codable {
    let scheduleSeq: Int
    let creatorSeq: Int
    let title: String
    let content: String?
}

struct ModifyFeedRequest: Codable {
    let feedSeq: Int
    let creatorSeq: Int
    let title: String
    let content: String?
}
