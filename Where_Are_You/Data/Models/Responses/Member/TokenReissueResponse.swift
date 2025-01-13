//
//  TokenReissueResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 13/1/2025.
//

import Foundation

struct TokenReissueResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let memberSeq: Int
}
