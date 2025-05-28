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
    
    var onPasswordValidation: ((String, Bool) -> Void)?
    var onPasswordCheck: ((String, Bool) -> Void)?
    var onResetPasswordSuccess: (() -> Void)?
    
    // MARK: - Lifecycle

    init(resetPasswordUseCase: ResetPasswordUseCase) {
        self.resetPasswordUseCase = resetPasswordUseCase
    }
    
    // MARK: - Helpers

    func resetPassword(email: String, password: String, checkPassword: String) {
        resetPasswordUseCase.execute(request: ResetPasswordBody(email: email, password: password, checkPassword: checkPassword)) { [weak self] result in
            switch result {
            case .success:
                self?.onResetPasswordSuccess?()
            case .failure: 
                break
            }
        }
    }
    
    func checkPasswordForm(pw: String) {
        if ValidationHelper.isValidPassword(pw) {
            onPasswordValidation?("", true)
        } else {
            onPasswordValidation?("영문 대소문자로 시작하는 6~20자의 영문 대소문자, 숫자를 \n 포함해 입력해주세요.", false)
        }
    }
    
    func checkSamePassword(pw: String, checkpw: String) {
        if ValidationHelper.isPasswordSame(pw, checkpw: checkpw) {
            onPasswordCheck?("비밀번호가 일치합니다.", true)
        } else {
            onPasswordCheck?("비밀번호가 일치하지 않습니다.", false)
        }
    }
}
