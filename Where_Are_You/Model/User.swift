//
//  User.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

struct User {
    let username: String
    let email: String
    let userID: String
    let uid: String
    
    init(username: String, email: String, userID: String, uid: String) {
        self.username = username
        self.email = email
        self.userID = userID
        self.uid = uid
    }
    
}
