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
    
    var onRequestCodeSuccess: ((String) -> Void)?
    var onRequestCodeFailure: ((String) -> Void)?
    var onVerifyCodeSuccess: (() -> Void)?
    var onVerifyCodeFailure: ((String) -> Void)?
    var onFindIDSuccess: ((String) -> Void)?
    var onFindIDFailure: ((String) -> Void)?
    
    var onResetPasswordSuccess: (() -> Void)?
    var onResetPasswordFailure: ((String) -> Void)?
    
    var onUpdateTimer: ((String) -> Void)?
    private var timer: Timer?
    private var timerCount: Int = 300
    
    
    init(sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase,
         verifyEmailCodeUseCase: VerifyEmailCodeUseCase,
         resetPasswordUseCase: ResetPasswordUseCase) {
        self.sendEmailVerificationCodeUseCase = sendEmailVerificationCodeUseCase
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
        self.resetPasswordUseCase = resetPasswordUseCase
    }
    
    func sendEmailVerificationCode(userId: String) {
        sendEmailVerificationCodeUseCase.execute(userId: userId) { [weak self] result in
            switch result {
            case .success:
                self?.onRequestCodeSuccess?("인증코드가 전송되었습니다.")
                self?.userId = userId
                self?.startTimer()
            case .failure(let error):
                self?.onRequestCodeFailure?(error.localizedDescription)
            }
        }
    }
    
    func verifyPassword(code: String) {
        if timerCount == 0 {
            self.onVerifyCodeFailure?("이메일 재인증 요청이 필요합니다.")
        } else {
            verifyEmailCodeUseCase.execute(userId: userId, code: code) { [weak self] result in
                switch result {
                case .success():
                    self?.onFindIDSuccess?(("인증코드가 확인되었습니다."))
                case .failure(let error):
                    self?.onFindIDFailure?(error.localizedDescription)
                }
            }
        }
    }
    
    func resetPassword(password: String, checkPassword: String) {
        resetPasswordUseCase.execute(userId: userId, password: password, checkPassword: checkPassword) { [weak self] result in
            switch result {
            case .success():
                self?.onResetPasswordSuccess?()
            case .failure(let error):
                self?.onResetPasswordFailure?(error.localizedDescription)
            }
        }
    }
    
    // 타이머 시작
    func startTimer() {
        timerCount = 300
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timerCount -= 1
            let minutes = self.timerCount / 60
            let seconds = self.timerCount % 60
            let timeString = String(format: "%02d:%02d", minutes, seconds)
            self.onUpdateTimer?(timeString)
            if self.timerCount == 0 {
                self.stopTimer()
                self.onVerifyCodeFailure?("이메일 재인증 요청이 필요합니다.")
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
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
