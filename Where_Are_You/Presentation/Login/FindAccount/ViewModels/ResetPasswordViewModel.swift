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
    func resetPassword(userId: String, password: String, checkPassword: String) {
        guard ValidationHelper.isValidPassword(password) else {
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
        if ValidationHelper.isValidPassword(pw) {
            onCheckPasswordForm?("", true)
        } else {
            onCheckPasswordForm?("영문 대문자, 소문자로 시작하는 6~20자의 영문 대문자, 소문자, 숫자를 포함해 입력해주세요.", false)
        }
    }
    
    func checkSamePassword(pw: String, checkpw: String) {
        if ValidationHelper.isPasswordSame(pw, checkpw: checkpw) {
            onCheckSamePassword?("", true)
        } else {
            onCheckSamePassword?("비밀번호가 일치하지 않습니다.", false)
        }
    }
}
