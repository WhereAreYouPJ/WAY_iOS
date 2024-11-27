//
//  GetFriendRequestResponse.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Foundation

struct GetListForReceiverResponse: Codable {
    let friendRequestSeq: Int
    let senderSeq: Int
    let createTime: String
    let profileImage: String?
    let userName: String
}
