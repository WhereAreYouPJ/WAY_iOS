//
//  LoginResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/8/2024.
//

import Foundation

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let memberSeq: Int
    let memberCode: String
    let profileImage: String
}
