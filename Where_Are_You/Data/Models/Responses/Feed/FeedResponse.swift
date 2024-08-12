//
//  ReadFeedResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/8/2024.
//

import Foundation

struct FeedResponse: Codable {
    let profileImage: String? // Base64 이미지 문자열
    let date: String // 서버의 날짜 문자열
    let location: String
    let title: String
    let feedImages: [String] // Base64 이미지 문자열 배열
    let description: String?
}
