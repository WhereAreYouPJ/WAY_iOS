//
//  AuthCredentials.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import UIKit

// MARK: - SignUpBody

struct SignUpBody: Codable {
    var userName: String?
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

struct ResetPasswordBody: Codable {
    let email: String
    let password: String
    let checkPassword: String
}

struct LogoutBody: Codable {
    let memberSeq: Int
}

struct LoginBody: Codable {
    let email: String
    let password: String
}

struct EmailVerifyBody: Codable {
    let email: String
    let code: String
}

struct EmailVerifyPasswordBody: Codable {
    let email: String
    let code: String
}

struct EmailSendBody: Codable {
    let email: String
}

struct SearchBody: Codable {
    let memberCode: String
}

struct DetailsBody: Codable {
    let memberSeq: Int
}

struct CheckEmailBody: Codable {
    let email: String
}
