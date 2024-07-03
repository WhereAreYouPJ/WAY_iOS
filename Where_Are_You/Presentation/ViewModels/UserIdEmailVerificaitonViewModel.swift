//
//  UserIdEmailVerificaitonViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/7/2024.
//

import Foundation

class UserIdEmailVerificaitonViewModel {
    
    // MARK: - Properties
    private let sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase
    private let verifyEmailCodeUseCase: VerifyEmailCodeUseCase
    
    var userId: String = ""
    var code: String = ""
    
    var onRequestCodeSuccess: ((String) -> Void)?
    var onRequestCodeFailure: ((String) -> Void)?
    var onVerifyCodeSuccess: ((String) -> Void)?
    var onVerifyCodeFailure: ((String) -> Void)?
    var onVerifySuccess: (() -> Void)?
    var onVerifyFailure: ((String) -> Void)?
    
    var okayToMove = false
    
    var onUpdateTimer: ((String) -> Void)?
    private var timer: Timer?
    private var timerCount: Int = 300
    
    init(sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase,
         verifyEmailCodeUseCase: VerifyEmailCodeUseCase) {
        self.sendEmailVerificationCodeUseCase = sendEmailVerificationCodeUseCase
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
    }
    
    // userID를 통해 이메일 인증코드 보내기
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
    
    // 인증코드와 userID를 함께 보내서 인증받기
    func verifyEmailCode(code: String) {
        if timerCount == 0 {
            self.onVerifyCodeFailure?("이메일 재인증 요청이 필요합니다.")
        } else {
            verifyEmailCodeUseCase.execute(userId: userId, code: code) { [weak self] result in
                switch result {
                case .success:
                    self?.onVerifyCodeSuccess?("인증코드가 확인되었습니다.")
                    self?.okayToMove = true
                case .failure(let error):
                    self?.onVerifyCodeFailure?(error.localizedDescription)
                }
            }
        }
    }
    
    func moveToReset() {
        if okayToMove {
            self.onVerifySuccess?()
        } else {
            self.onVerifyFailure?("아이디 혹은 인증코드를 다시 한번 확인해 주세요")
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
}
