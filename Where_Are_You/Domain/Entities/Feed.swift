//
//  Feed.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit

struct Feed {
    var profileImage: UIImage 
    let date: String?
    let location: String
    let title: String
    
    var feedImages: [UIImage]?
    let description: String?
}

struct CreateFeed {
    let scheduleSeq: Int
    let creatorSeq: Int
    let title: String
    let content: String
    var images: [UIImage]?
}
