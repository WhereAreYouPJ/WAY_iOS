//
//  Friend.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import Foundation

struct Friend: Identifiable {
    let id = UUID()
    let memberSeq: Int
    let profileImage: String
    let name: String
    var isFavorite: Bool
}
