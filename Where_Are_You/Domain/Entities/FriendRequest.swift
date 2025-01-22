//
//  FriendRequest.swift
//  Where_Are_You
//
//  Created by juhee on 28.11.24.
//

import Foundation

struct FriendRequest: Identifiable {
    let id: UUID = UUID()
    let friendRequestSeq: Int
    let createTime: Date
    let friend: Friend
}
