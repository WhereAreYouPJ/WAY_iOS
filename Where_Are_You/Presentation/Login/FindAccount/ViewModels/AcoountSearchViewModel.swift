//
//  FindAccountViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class AcoountSearchViewModel {
    
    // MARK: - Properties
    private let emailSendUseCase: EmailSendUseCase
    private let emailVerifyUseCase: EmailVerifyUseCase
    
    private let timerHelper = TimerHelper()
    
    private var email: String = ""
    
    // Output
    var onRequestCodeSuccess: ((String) -> Void)?
    var onRequestCodeFailure: ((String) -> Void)?
    var onVerifyCodeSuccess: ((String) -> Void)?
    var onVerifyCodeFailure: ((String) -> Void)?
    var onAccountSearchSuccess: (() -> Void)?
    var onAccountSearchFailure: (() -> Void)?
    
    var onUpdateTimer: ((String) -> Void)?
    
    private var timer: Timer?
    private var timerCount: Int = 300
    
    // MARK: - LifeCycle
    
    init(emailSendUseCase: EmailSendUseCase,
         emailVerifyUseCase: EmailVerifyUseCase) {
        self.emailSendUseCase = emailSendUseCase
        self.emailVerifyUseCase = emailVerifyUseCase
    }
    
    // MARK: - Helpers
    
    func requestEmailCode(email: String) {
        guard ValidationHelper.isValidEmail(email) else {
            onRequestCodeFailure?("이메일 형식에 알맞지 않습니다.")
            return
        }
        
        emailSendUseCase.execute(request: EmailSendBody(email: email)) { [weak self] result in
            switch result {
            case .success:
                self?.onRequestCodeSuccess?("인증코드가 전송되었습니다.")
                self?.email = email
                self?.startTimer()
            case .failure(let error):
                self?.onRequestCodeFailure?("입력한 이메일 주소를 다시 확인해주세요.")
            }
        }
    }
    
    func verifyEmailCode(inputCode: String) {
        if timerHelper.timerCount == 0 {
            self.onVerifyCodeFailure?("이메일 재인증 요청이 필요합니다.")
        } else {
            emailVerifyUseCase.execute(request: EmailVerifyBody(email: email, code: inputCode)) { result in
                switch result {
                case .success:
                    self.onVerifyCodeSuccess?("인증코드가 확인되었습니다.")
                case .failure(let error):
                    self.onVerifyCodeFailure?("인증코드가 알맞지 않습니다.")
                }
            }
        }
    }
    
    func okayToMove() {
        if !email.isEmpty {
            // TODO: 추후에 어떤 방식으로 회원가입을 했는지 확인하는 API추가해서 그 정보를 다음페이지로 넘기기
            onAccountSearchSuccess?()
        } else {
            onAccountSearchFailure?()
        }
    }
    
    private func startTimer() {
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
