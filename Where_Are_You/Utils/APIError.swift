//
//  APIError.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/1/2025.
//

import Foundation

enum APIError: Error {
    case emailError
    case passwordError
    case serverError
    case appleError
    case unknownError(message: String)

    init(code: String, message: String) {
        switch code {
        case "EB009":
            self = .emailError
        case "PB005":
            self = .passwordError
        case "S500":
            self = .serverError
        case "AN008":
            self = .appleError
        default:
            self = .unknownError(message: message)
        }
    }

    var localizedDescription: String {
        switch self {
        case .emailError:
            return "이메일 또는 비밀번호를 확인해주세요."
        case .passwordError:
            return "이메일 또는 비밀번호를 확인해주세요."
        case .serverError:
            return "서버에 오류가 발생했습니다."
        case .appleError:
            return "회원가입을 진행해주세요."
        case .unknownError(let message):
            return message.isEmpty ? "알 수 없는 오류가 발생했습니다." : message
        }
    }
}
