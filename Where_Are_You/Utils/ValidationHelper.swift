//
//  ValidationHelper.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/7/2024.
//

import Foundation

// MARK: - ValidationHelper (입력 형식 조건 확인)

class ValidationHelper {
    static func isValidUserName(_ userName: String) -> Bool {
        let nameRegex = "^[가-힣]{1,4}$"
        let userNamePred = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return userNamePred.evaluate(with: userName)
    }

    static func isValidPassword(_ pw: String) -> Bool {
        let pwRegex = "^(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?])[a-z0-9!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]{6,20}$"
        let pwPred = NSPredicate(format: "SELF MATCHES %@", pwRegex)
        return pwPred.evaluate(with: pw)
    }

    static func isPasswordSame(_ pw: String, checkpw: String) -> Bool {
        return pw == checkpw
    }

    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,64}$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
