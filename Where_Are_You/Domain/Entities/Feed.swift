//
//  Feed.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit

struct Feed {
    let profileImage: UIImage? // 추후 string으로 바꿔야함
    let date: Date?
    let location: String
    let title: String
    
    let feedImages: [UIImage]?
    let description: String?
}

extension Feed {
    init(from response: ReadFeedResponse) {
        self.profileImage = response.profileImage.flatMap { ImageUtility.decodeBase64StringToImage($0) }
        
        // 날짜 변환
        let dateFormatter = ISO8601DateFormatter()
        self.date = dateFormatter.date(from: response.date) // ISO 8601 형식으로 변환

        self.location = response.location
        self.title = response.title

        // 이미지 변환
        self.feedImages = response.feedImages.compactMap { ImageUtility.decodeBase64StringToImage($0) }
        self.description = response.description
    }
}
