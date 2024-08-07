//
//  MemberSearchResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/8/2024.
//

import Foundation

struct MemberSearchResponse: Codable {
    let userName: String
    let memberSeq: Int
    let profileImage: String
}
