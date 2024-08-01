//
//  AuthCredentials.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import UIKit

// MARK: - ParameterConvertible

protocol ParameterConvertible: Codable {
    func toParameters() -> [String: Any]?
}

extension ParameterConvertible {
    func toParameters() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return json
    }
}
