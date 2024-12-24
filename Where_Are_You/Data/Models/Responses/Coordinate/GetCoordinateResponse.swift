//
//  GetCoordinateResponse.swift
//  Where_Are_You
//
//  Created by juhee on 09.12.24.
//

import Foundation

struct GetCoordinateResponse: Codable {
    let memberSeq: Int
    let userName: String
    let profileImage: String
    let x: Double
    let y: Double
}
