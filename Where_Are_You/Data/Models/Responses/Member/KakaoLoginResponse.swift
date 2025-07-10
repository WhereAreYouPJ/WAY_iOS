//
//  KakaoLoginResponse.swift
//  Where_Are_You
//
//  Created by juhee on 07.07.25.
//

import Foundation

struct KakaoLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let memberSeq: Int
    let memberCode: String
    let profileImage: String
}
