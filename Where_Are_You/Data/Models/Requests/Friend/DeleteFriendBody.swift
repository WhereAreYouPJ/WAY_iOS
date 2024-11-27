//
//  DeleteFriendRequest.swift
//  Where_Are_You
//
//  Created by juhee on 15.11.24.
//

import Foundation

struct DeleteFriendBody: ParameterConvertible {
    let memberSeq: Int
    let friendSeq: Int
}
