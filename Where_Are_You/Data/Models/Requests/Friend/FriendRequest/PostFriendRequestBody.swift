//
//  PostFriendBody.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Foundation

struct PostFriendRequestBody: ParameterConvertible {
    let memberSeq: Int
    let friendSeq: Int
}
