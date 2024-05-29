//
//  User.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

struct User {
    let id: Int
    let name: String
    let email: String
    let password: String
    let profileImageUrl: String?
    let friends: [User]
}
