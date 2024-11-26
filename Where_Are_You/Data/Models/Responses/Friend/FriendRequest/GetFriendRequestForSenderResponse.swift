//
//  GetFriendRequestListResponse.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Foundation

struct GetFriendRequestForSenderResponse: Codable {
    let friendRequestSeq: Int
    let receiverSeq: Int
    let createTime: String
    let profileImage: String?
    let userName: String
}
