//
//  PasswordResetViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/7/2024.
//

import Foundation

class ResetPasswordViewModel {
    
    // MARK: - Properties
    private let resetPasswordUseCase: ResetPasswordUseCase
    
    var userId: String = ""
    var password: String = ""
    var checkPassword: String = ""
    
    var onResetPasswordSuccess: (() -> Void)?
    var onResetPasswordFailure: ((String) -> Void)?
    
    var onCheckPasswordForm: ((String, Bool) -> Void)?
    var onCheckSamePassword: ((String, Bool) -> Void)?
    
    init(resetPasswordUseCase: ResetPasswordUseCase) {
        self.resetPasswordUseCase = resetPasswordUseCase
    }
    
    // 이전의 확인받은 userID와 패스워드 체크 패스워드 입력해서 변경하기
    func resetPassword(password: String, checkPassword: String) {
        guard isValidPassword(password) else {
            onResetPasswordFailure?("비밀번호를 다시 한번 확인해 주세요")
            return
        }
        
        guard password == checkPassword else {
            onResetPasswordFailure?("비밀번호를 다시 한번 확인해 주세요")
            return
        }
        
        resetPasswordUseCase.execute(userId: userId, password: password, checkPassword: checkPassword) { [weak self] result in
            switch result {
            case .success:
                self?.onResetPasswordSuccess?()
            case .failure(let error):
                self?.onResetPasswordFailure?(error.localizedDescription)
            }
        }
    }
    
    func checkPasswordForm(pw: String) {
        if isValidPassword(pw) {
            onCheckPasswordForm?("", true)
        } else {
            onCheckPasswordForm?("", false)
        }
    }
    
    func checkSamePassword(pw: String, checkpw: String) {
        if isPasswordSame(pw, checkpw: checkpw) {
            onCheckSamePassword?("", true)
        } else {
            onCheckSamePassword?("", false)
        }
    }
    
    func isValidPassword(_ pw: String) -> Bool {
        let pwRegex = "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z][A-Za-z0-9]{5,19}$"
        let pwPred = NSPredicate(format: "SELF MATCHES %@", pwRegex)
        return pwPred.evaluate(with: pw)
    }
    
    func isPasswordSame(_ pw: String, checkpw: String) -> Bool {
        return pw == checkpw
    }
}
