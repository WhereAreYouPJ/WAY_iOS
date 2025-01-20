//
//  KakaoLocalResponse.swift
//  Where_Are_You
//
//  Created by juhee on 07.09.24.
//

import Foundation

struct KakaoLocalResponse: Codable {
    let documents: [Document]
}

struct Document: Codable {
    let id: String
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName = "place_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case x, y
    }
    
    func toLocation() -> Location {
        Location(
            id: UUID(), // UUID를 생성하거나 id를 사용할 수 있습니다.
            sequence: 0,
            location: placeName,
            streetName: roadAddressName.isEmpty ? addressName : roadAddressName,
            x: Double(x) ?? 0,
            y: Double(y) ?? 0
        )
    }
}
