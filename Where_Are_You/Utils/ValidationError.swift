//
//  ValidationError.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/8/2024.
//

import Foundation

enum ValidationError: Error {
    case invalidEmailFormat
    case duplicateEmail
    case emailVerificationExpired
    case emailVerificationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidEmailFormat:
            return "이메일 형식에 알맞지 않습니다."
        case .duplicateEmail:
            return "입력한 이메일 주소를 다시 확인해주세요."
        case .emailVerificationExpired:
            return "이메일 재인증 요청이 필요합니다."
        case .emailVerificationFailed:
            return "인증코드가 알맞지 않습니다."
        }
    }
}
