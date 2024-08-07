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
    private let checkEmailUseCase: CheckEmailUseCase
    private let emailSendUseCase: EmailSendUseCase
    private let emailVerifyUseCase: EmailVerifyUseCase
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
    var onEmailVerifyCodeMessage: ((String, Bool) -> Void)?
    
    var onPasswordFormatMessage: ((String, Bool) -> Void)?
    var onCheckPasswordFormatMessage: ((String, Bool) -> Void)?
    
    // MARK: - LifeCycle
    
    init(accountSignUpUseCase: AccountSignUpUseCase,
         checkEmailUseCase: CheckEmailUseCase,
         emailSendUseCase: EmailSendUseCase,
         emailVerifyUseCase: EmailVerifyUseCase) {
        self.accountSignUpUseCase = accountSignUpUseCase
        self.checkEmailUseCase = checkEmailUseCase
        self.emailSendUseCase = emailSendUseCase
        self.emailVerifyUseCase = emailVerifyUseCase
        
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
    
    private func updateSignUpButtonState() {
        let isButtonEnabled = signUpBody.userName != nil && signUpBody.email != nil && signUpBody.password != nil
        onSignUpButtonState?(isButtonEnabled)
    }
    
    // 이름 형식 체크
    func checkUserNameValidation(userName: String) {
        if ValidationHelper.isValidUserName(userName) {
            onUserNameValidationMessage?("", true)
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
        if ValidationHelper.isPasswordSame(password, checkpw: checkPassword) {
            onCheckPasswordFormatMessage?("", true)
            signUpBody.password = checkPassword
        } else {
            onCheckPasswordFormatMessage?("비밀번호가 일치하지 않습니다.", false)
            signUpBody.password = nil
        }
    }
    
    // 이메일 중복체크
    func checkEmailAvailability(email: String) {
        guard ValidationHelper.isValidEmail(email) else {
            onEmailSendMessage?(invalidEmailMessage, false)
            return
        }
        
        checkEmailUseCase.execute(request: CheckEmailParameters(email: email)) { result in
            switch result {
            case .success(let data):
                self.timerHelper.startTimer()
                self.sendEmailVerificationCode(email: data.email)
            case .failure:
                self.onEmailSendMessage?("중복된 이메일입니다.", false)
            }
        }
    }
    
    // 인증코드 전송
    func sendEmailVerificationCode(email: String) {
        emailSendUseCase.execute(request: EmailSendBody(email: email)) { result in
            switch result {
            case .success:
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
                    self.onEmailVerifyCodeMessage?(emailVerifySuccessMessage, true)
                case .failure(let error):
                    self.onEmailVerifyCodeMessage?(error.localizedDescription, false)
                    self.signUpBody.email = nil
                }
            }
        }
    }
}
