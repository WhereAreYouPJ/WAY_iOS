//
//  FindAccountViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class FindIDViewModel {
    
    // MARK: - Properties
    private let sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase
    private let findUserIDUseCase: FindUserIDUseCase
    
    var email: String = ""
    
    // Output
    var onRequestCodeSuccess: (() -> Void)?
    var onRequestCodeFailure: ((String) -> Void)?
    var onVerifyCodeSuccess: (() -> Void)?
    var onVerifyCodeFailure: ((String) -> Void)?
    var onFindIDSuccess: ((String) -> Void)?
    var onFindIDFailure: ((String) -> Void)?
    
    var onUpdateTimer: ((String) -> Void)?
    
    private var timer: Timer?
    private var timerCount: Int = 300
    
    // MARK: - LifeCycle
    
    init(sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase,
         findUserIDUseCase: FindUserIDUseCase) {
        self.sendEmailVerificationCodeUseCase = sendEmailVerificationCodeUseCase
        self.findUserIDUseCase = findUserIDUseCase
    }
    
    // MARK: - Helpers
    
    func sendEmailVerificationCode(email: String) {
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
    
    // 수정해야하는 부분(userid 받을수 있게 response 수정 해야함)
    func findUserID(code: String) {
        if timerCount == 0 {
            self.onVerifyCodeFailure?("이메일 재인증 요청이 필요합니다.")
        } else {
            findUserIDUseCase.execute(email: email, code: code) { [weak self] result in
                switch result {
                case .success(let userId):
                    self?.onFindIDSuccess?(userId)
                case .failure(let error):
                    self?.onFindIDFailure?(error.localizedDescription)
                }
            }
        }
    }
    
    // 타이머 시작
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
    
    // MARK: - Validation Helpers
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
