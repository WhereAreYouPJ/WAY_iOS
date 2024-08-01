//
//  ValidationHelper.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/7/2024.
//

import Foundation

// MARK: - ValidationHelper (입력 형식 조건 확인)

class ValidationHelper {
    // TODO: 아이디 조건말고 이름 조건으로 변경하기
    static func isValidUserID(_ userID: String) -> Bool {
        let idRegex = "^[a-z][a-z0-9]{4,11}$"
        let userIDPred = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return userIDPred.evaluate(with: userID)
    }

    static func isValidPassword(_ pw: String) -> Bool {
        let pwRegex = "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z][A-Za-z0-9]{5,19}$"
        let pwPred = NSPredicate(format: "SELF MATCHES %@", pwRegex)
        return pwPred.evaluate(with: pw)
    }

    static func isPasswordSame(_ pw: String, checkpw: String) -> Bool {
        return pw == checkpw
    }

    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
