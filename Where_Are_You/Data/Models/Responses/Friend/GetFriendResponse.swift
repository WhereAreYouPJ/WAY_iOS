//
//  GetFriendResponse.swift
//  Where_Are_You
//
//  Created by juhee on 13.11.24.
//

import Foundation

typealias GetFriendResponse = [FriendsResponse]

struct FriendsResponse: Codable {
    let memeberSeq: Int
    let userName: String
    let profileImage: String?
    let Favorites: Bool
}
