//
//  DeleteFavoriteFriendBody.swift
//  Where_Are_You
//
//  Created by juhee on 15.11.24.
//

import Foundation

struct DeleteFavoriteFriendBody: ParameterConvertible {
    let friendSeq: Int
    let memberSeq: Int
}
