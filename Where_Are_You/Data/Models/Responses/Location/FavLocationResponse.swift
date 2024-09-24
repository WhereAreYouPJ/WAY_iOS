//
//  LocationResponse.swift
//  Where_Are_You
//
//  Created by juhee on 01.09.24.
//

import Foundation

struct FavLocation: Codable {
    let locationSeq: Int
    let location: String
    let streetName: String
}

typealias GetFavLocationResponse = [FavLocation]

struct PostFavLocation: Codable {
    let locationSeq: Int
}
