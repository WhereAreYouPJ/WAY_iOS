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
    
    var onPasswordValidation: ((Bool) -> Void)?
    var onPasswordCheck: ((Bool) -> Void)?
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
            onPasswordValidation?(true)
        } else {
            onPasswordValidation?(false)
        }
    }
    
    func checkSamePassword(pw: String, checkpw: String) {
        if ValidationHelper.isPasswordSame(pw, checkpw: checkpw) {
            onPasswordCheck?(true)
        } else {
            onPasswordCheck?(false)
        }
    }
}
