//
//  User.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

struct User: Codable {
    let name: String
    let id: Int?
    let password: String?
    let email: String
}
