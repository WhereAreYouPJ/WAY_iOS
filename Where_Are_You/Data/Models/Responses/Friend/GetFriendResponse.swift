//
//  GetFriendResponse.swift
//  Where_Are_You
//
//  Created by juhee on 13.11.24.
//

import Foundation

struct GetFriendResponse: Codable {
    let memberSeq: Int
    let userName: String
    let profileImage: String?
    let favorites: Bool
}
