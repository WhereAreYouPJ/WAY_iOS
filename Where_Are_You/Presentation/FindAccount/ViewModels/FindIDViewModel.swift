//
//  FindAccountViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class FindIDViewModel {
    
    // MARK: - Properties
    private let sendVerificationCodeUseCase: SendVerificationCodeUseCase
    private let findUserIDUseCase: FindUserIDUseCase
    private let verifyCodeUseCase: VerifyCodeUseCase
    
    private let timerHelper = TimerHelper()
    
    var email: String = ""
    var userId: String = ""
    
    // Output
    var onRequestCodeSuccess: ((String) -> Void)?
    var onRequestCodeFailure: ((String) -> Void)?
    var onVerifyCodeSuccess: ((String) -> Void)?
    var onVerifyCodeFailure: ((String) -> Void)?
    var onFindIDSuccess: ((String) -> Void)?
    var onFindIDFailure: ((String) -> Void)?
    
    var onUpdateTimer: ((String) -> Void)?
    
    private var timer: Timer?
    private var timerCount: Int = 300
    
    // MARK: - LifeCycle
    
    init(sendVerificationCodeUseCase: SendVerificationCodeUseCase,
         findUserIDUseCase: FindUserIDUseCase,
         verifyCodeUseCase: VerifyCodeUseCase) {
        self.sendVerificationCodeUseCase = sendVerificationCodeUseCase
        self.findUserIDUseCase = findUserIDUseCase
        self.verifyCodeUseCase = verifyCodeUseCase
    }
    
    // MARK: - Helpers
    
    func sendEmailVerificationCode(email: String) {
        guard ValidationHelper.isValidEmail(email) else {
            onRequestCodeFailure?("이메일 형식에 알맞지 않습니다.")
            return
        }
        
        sendVerificationCodeUseCase.execute(identifier: email, type: .email) { [weak self] result in
            switch result {
            case .success:
                self?.onRequestCodeSuccess?("인증코드가 전송되었습니다.")
                self?.email = email
                self?.startTimer()
            case .failure(let error):
                self?.onRequestCodeFailure?(error.localizedDescription)
            }
        }
    }
    
    // 수정해야하는 부분(userid 받을수 있게 response 수정 해야함)
    func verifyEmailCode(inputCode: String) {
        if timerHelper.timerCount == 0 {
            self.onVerifyCodeFailure?("인증코드 시간 지남")
        } else {
            verifyCodeUseCase.execute(identifier: email, code: inputCode, type: .email) { result in
                switch result {
                case .success:
                    self.onVerifyCodeSuccess?("인증성공")
                case .failure(let error):
                    self.onVerifyCodeFailure?(error.localizedDescription)
                }
            }
        }
    }
    
    func okayToMove() {
        if !userId.isEmpty {
            onFindIDSuccess?(userId)
        } else {
            onFindIDFailure?("이메일 혹은 인증코드를 다시 한번 확인해 주세요")
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
}
