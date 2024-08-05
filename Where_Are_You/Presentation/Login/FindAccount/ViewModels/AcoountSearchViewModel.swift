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
    private let checkEmailUseCase: CheckEmailUseCase
    private let timerHelper = TimerHelper()
    private var email: String = ""
    
    // Output
    var onRequestCodeSuccess: ((String) -> Void)?
    var onRequestCodeFailure: ((String) -> Void)?
    var onVerifyCodeSuccess: ((String) -> Void)?
    var onVerifyCodeFailure: ((String) -> Void)?
    var onAccountSearchSuccess: ((String) -> Void)?
    var onAccountSearchFailure: (() -> Void)?
    
    var onUpdateTimer: ((String) -> Void)?
    
    // MARK: - LifeCycle
    
    init(emailSendUseCase: EmailSendUseCase,
         emailVerifyUseCase: EmailVerifyUseCase,
         checkEmailUseCase: CheckEmailUseCase) {
        self.emailSendUseCase = emailSendUseCase
        self.emailVerifyUseCase = emailVerifyUseCase
        self.checkEmailUseCase = checkEmailUseCase
        
        timerHelper.onUpdateTimer = { [weak self] timeString in
            self?.onUpdateTimer?(timeString)
        }
    }
    
    // MARK: - Helpers
    
    // 이메일 중복체크
    func checkEmailAvailability(email: String) {
        guard ValidationHelper.isValidEmail(email) else {
            onRequestCodeFailure?(invalidEmailMessage)
            return
        }
        
        checkEmailUseCase.execute(request: CheckEmailParameters(email: email)) { result in
            switch result {
            case .success:
                self.onRequestCodeFailure?("입력한 이메일 주소를 다시 확인해주세요.")
            case .failure:
                self.timerHelper.startTimer()
                self.requestEmailCode(email: email)
            }
        }
    }
    
    func requestEmailCode(email: String) {
        emailSendUseCase.execute(request: EmailSendBody(email: email)) { [weak self] result in
            switch result {
            case .success:
                self?.onRequestCodeSuccess?("인증코드가 전송되었습니다.")
                self?.email = email
                self?.timerHelper.startTimer()
            case .failure:
                self?.onRequestCodeFailure?("입력한 이메일 주소를 다시 확인해주세요.")
            }
        }
    }
    
    func verifyEmailCode(code: String) {
        if timerHelper.timerCount == 0 {
            self.onVerifyCodeFailure?("이메일 재인증 요청이 필요합니다.")
        } else {
            emailVerifyUseCase.execute(request: EmailVerifyBody(email: email, code: code)) { result in
                switch result {
                case .success:
                    self.onVerifyCodeSuccess?("인증코드가 확인되었습니다.")
                case .failure:
                    self.onVerifyCodeFailure?("인증코드가 알맞지 않습니다.")
                }
            }
        }
    }
    
    func okayToMove() {
        if !email.isEmpty {
            // TODO: 추후에 어떤 방식으로 회원가입을 했는지 확인하는 API추가해서 그 정보를 다음페이지로 넘기기
            onAccountSearchSuccess?(email)
        } else {
            onAccountSearchFailure?()
        }
    }
}
