//
//  User.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

struct User: Codable {
    let userName: String
    let userID: Int?
    let password: String?
    let email: String
    
    init?(json: [String: Any]) {
        guard let userID = json["userID"] as? String,
              let password = json["password"] as? String,
              let email = json["email"] as? String else { return nil }
        
        self.userID = userID
        self.password = password
        self.email = email
    }
}
