//
//  AcceptFriendRequestBody.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Foundation

struct AcceptFriendRequestBody: ParameterConvertible {
    let friendRequestSeq: Int
    let memberSeq: Int
    let senderSeq: Int
}
