//
//  ServerError.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/1/2025.
//

import Foundation

struct ServerError: Codable, Error {
    let code: String
    let message: String
    let status: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
        self.status = try? container.decode(Int.self, forKey: .status)
    }

    private enum CodingKeys: String, CodingKey {
        case code, message, status
    }
}
