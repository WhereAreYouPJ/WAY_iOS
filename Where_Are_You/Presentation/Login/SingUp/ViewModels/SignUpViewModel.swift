//
//  RegisterViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class SignUpViewModel {
    
    // MARK: - Properties
    private let accountSignUpUseCase: AccountSignUpUseCase
//    private let kakaoJoinUseCase: KakaoJoinUseCase
    
    private let emailVerifyUseCase: EmailVerifyUseCase
    private let emailSendV2UseCase: EmailSendV2UseCase
    
    private let timerHelper = TimerHelper()
    
    var onUpdateTimer: ((String) -> Void)?
    
    // Input
    var signUpBody = SignUpBody() {
        didSet {
            updateSignUpButtonState()
        }
    }
    
    var email: String = ""
    
    // Output
    var onSignUpSuccess: (() -> Void)?
    var onSignUpButtonState: ((Bool) -> Void)?
    
    var onUserNameValidationMessage: ((String, Bool) -> Void)?
    
    var onEmailSendMessage: ((String, Bool) -> Void)?
    var onCheckEmailDuplicate: (([String]) -> Void)?
    var onEmailVerifyCodeMessage: ((String, Bool) -> Void)?
    
    var onPasswordFormatMessage: ((String, Bool) -> Void)?
    var onCheckPasswordFormatMessage: ((String, Bool) -> Void)?
    
    // MARK: - LifeCycle
    
    init(accountSignUpUseCase: AccountSignUpUseCase,
//         kakaoJoinUseCase: KakaoJoinUseCase,
         emailVerifyUseCase: EmailVerifyUseCase,
         emailSendV2UseCase: EmailSendV2UseCase) {
        self.accountSignUpUseCase = accountSignUpUseCase
//        self.kakaoJoinUseCase = kakaoJoinUseCase
        self.emailVerifyUseCase = emailVerifyUseCase
        self.emailSendV2UseCase = emailSendV2UseCase
        
        timerHelper.onUpdateTimer = { [weak self] timeString in
            self?.onUpdateTimer?(timeString)
        }
    }
    
    // MARK: - Helpers(로그인, 아이디, 이메일, 코드확인)
    
    // 회원가입
    func signUp() {
        accountSignUpUseCase.execute(request: signUpBody) { result in
            switch result {
            case .success:
                self.onSignUpSuccess?()
            case .failure:
                break
            }
        }
    }
    
//    // 카카오 회원가입
//    func kakaoJoin(userName: String, authCode: String) {
//        kakaoJoinUseCase.execute(request: KakaoJoinBody(userName: userName, code: authCode)) { result in
//            switch result {
//            case .success:
//                self.onSignUpSuccess?()
//            case .failure(let error):
//                break
//            }
//        }
//    }
    
    private func updateSignUpButtonState() {
        let isButtonEnabled = signUpBody.userName != nil && signUpBody.email != nil && signUpBody.password != nil
        onSignUpButtonState?(isButtonEnabled)
    }
    
    // 이름 형식 체크
    func checkUserNameValidation(userName: String) {
        if ValidationHelper.isValidUserName(userName) {
            onUserNameValidationMessage?("사용가능한 이름입니다.", true)
            signUpBody.userName = userName
        } else {
            onUserNameValidationMessage?(invalidUserNameMessage, false)
            signUpBody.userName = nil
        }
    }
    
    // 비밀번호 형식 체크
    func checkPasswordAvailability(password: String) {
        if ValidationHelper.isValidPassword(password) {
            onPasswordFormatMessage?("", true)
        } else {
            onPasswordFormatMessage?(invalidPasswordMessage, false)
        }
    }
    
    // 비밀번호 일치체크
    func checkSamePassword(password: String, checkPassword: String) {
        if !checkPassword.isEmpty {
            if ValidationHelper.isPasswordSame(password, checkpw: checkPassword) {
                onCheckPasswordFormatMessage?("비밀번호가 일치합니다.", true)
                signUpBody.password = checkPassword
            } else {
                onCheckPasswordFormatMessage?("비밀번호가 일치하지 않습니다.", false)
                signUpBody.password = nil
            }
        }
    }
    
    func checkSendEmail(email: String) {
        guard ValidationHelper.isValidEmail(email) else {
            onEmailSendMessage?(invalidEmailMessage, false)
            return
        }
        
        emailSendV2UseCase.execute(email: email) { result in
            switch result {
            case .success(let data):
                print(data)
                self.timerHelper.startTimer()
                self.email = email
                self.onEmailSendMessage?(sendEmailVerifyCodeSuccessMessage, true)
            case .failure(let error):
                self.onEmailSendMessage?(error.localizedDescription, false)

            }
        }
    }
    
    // 인증코드 확인
    func verifyEmailCode(inputCode: String) {
        if timerHelper.timerCount == 0 {
            self.onEmailVerifyCodeMessage?(emailVerifyExpiredMessage, false)
        } else {
            emailVerifyUseCase.execute(request: EmailVerifyBody(email: email, code: inputCode)) { result in
                switch result {
                case .success:
                    self.signUpBody.email = self.email
                    self.timerHelper.stopTimer()
                    self.onEmailVerifyCodeMessage?(emailVerifySuccessMessage, true)
                case .failure:
                    self.onEmailVerifyCodeMessage?("인증코드가 알맞지 않습니다.", false)
                    self.signUpBody.email = nil
                }
            }
        }
    }
}
