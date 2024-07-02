//
//  PasswordResetViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/7/2024.
//

import Foundation

class PasswordResetViewModel {
    
    // MARK: - Properties
    private let sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase
    private let verifyEmailCodeUseCase: VerifyEmailCodeUseCase
    private let resetPasswordUseCase: ResetPasswordUseCase
    
    var userId: String = ""
    var code: String = ""
    
    init(sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase,
         verifyEmailCodeUseCase: VerifyEmailCodeUseCase,
         resetPasswordUseCase: ResetPasswordUseCase) {
        self.sendEmailVerificationCodeUseCase = sendEmailVerificationCodeUseCase
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
        self.resetPasswordUseCase = resetPasswordUseCase
    }
    
    func sendEmailVerificationCode(userId: String) {
        guard isValidEmail(email) else {
            onRequestCodeFailure?("이메일 형식에 알맞지 않습니다.")
            return
        }
        
        sendEmailVerificationCodeUseCase.execute(email: email) { [weak self] result in
            switch result {
            case .success:
                self?.onRequestCodeSuccess?()
                self?.email = email
                self?.startTimer()
            case .failure(let error):
                self?.onRequestCodeFailure?(error.localizedDescription)
            }
        }
    }
}
