//
//  User.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

struct User: Codable {
    var userName: String?
    var userId: String?
    var password: String?
    var email: String?
    
    func toParameters() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return json
    }
}
