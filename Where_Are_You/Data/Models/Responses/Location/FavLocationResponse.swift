//
//  LocationResponse.swift
//  Where_Are_You
//
//  Created by juhee on 01.09.24.
//

import Foundation

struct GetFavLocation: Codable {
    let locationSeq: Int
    let location: String
    let streetName: String
    let sequence: Int
    let x: Double
    let y: Double
}

typealias GetFavLocationResponse = [GetFavLocation]

struct PostFavLocation: Codable {
    let locationSeq: Int
}
