//
//  Place.swift
//  Where_Are_You
//
//  Created by juhee on 13.08.24.
//

import Foundation

struct Location: Identifiable, Codable, Hashable {
    var id = UUID()
    var locationSeq: Int?   // 서버에서 사용하는 고유 식별자
    var sequence: Int       // 정렬 순서
    var location: String
    var streetName: String
    var x: Double
    var y: Double
}
