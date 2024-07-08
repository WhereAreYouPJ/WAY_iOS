//
//  RegisterViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class SignUpViewModel {
    
    // MARK: - Properties
    private let signUpUseCase: SignUpUseCase
    private let checkUserIDAvailabilityUseCase: CheckUserIDAvailabilityUseCase
    private let checkEmailAvailabilityUseCase: CheckEmailAvailabilityUseCase
    private let sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase
    private let verifyEmailCodeUseCase: VerifyEmailCodeUseCase
    private let timerHelper = TimerHelper()
    var user = User()
    
    // Input
    var password: String = ""
    var confirmPassword: String = ""
    var email: String = ""
    
    // Output
    var onSignUpSuccess: (() -> Void)?
    var onSignUpFailure: ((String) -> Void)?
    
    var onUserIDAvailabilityChecked: ((String, Bool) -> Void)?
    var onPasswordFormatError: ((String, Bool) -> Void)?
    var onCheckPasswordFormatError: ((String, Bool) -> Void)?
    var onEmailVerificationCodeSent: ((String, Bool) -> Void)?
    var onEmailVerificationCodeVerified: ((String, Bool) -> Void)?
    
    var onUpdateTimer: ((String) -> Void)?
    
    // 에러 description
    private let invalidUserIDMessage = "영문 소문자와 숫자만 사용하여, 영문 소문자로 시작하는 5~12자의 아이디를 입력해주세요"
    private let invalidPasswordMessage = "영문 대문자, 소문자로 시작하는 6~20자의 영문 대문자, 소문자, 숫자를 포함해 입력해주세요"
    private let invalidEmailMessage = "유효하지 않은 이메일 형식입니다."
    private let duplicateUserIDMessage = "중복된 아이디입니다."
    private let duplicateEmailMessage = "중복된 이메일 입니다."
    private let emailVerificationExpiredMessage = "이메일 재인증 요청이 필요합니다."
    private let emailVerificationSuccessMessage = "인증코드가 확인되었습니다."
    
    // MARK: - LifeCycle
    
    init(signUpUseCase: SignUpUseCase,
         checkUserIDAvailabilityUseCase: CheckUserIDAvailabilityUseCase,
         checkEmailAvailabilityUseCase: CheckEmailAvailabilityUseCase,
         sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase,
         verifyEmailCodeUseCase: VerifyEmailCodeUseCase) {
        self.signUpUseCase = signUpUseCase
        self.checkUserIDAvailabilityUseCase = checkUserIDAvailabilityUseCase
        self.checkEmailAvailabilityUseCase = checkEmailAvailabilityUseCase
        self.sendEmailVerificationCodeUseCase = sendEmailVerificationCodeUseCase
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
        
        timerHelper.onUpdateTimer = { [weak self] timeString in
            self?.onUpdateTimer?(timeString)
        }
        
        timerHelper.onTimerExpired = { [weak self]  in
            self?.onEmailVerificationCodeVerified?("이메일 재인증 요청이 필요합니다.", false)
        }
    }
    
    // MARK: - Helpers(로그인, 아이디, 이메일, 코드확인)
    
    // 회원가입
    func signUp() {
        guard validateSignUpInputs() else { return }
        
        user.password = confirmPassword
        signUpUseCase.execute(request: user) { result in
            switch result {
            case .success:
                self.onSignUpSuccess?()
            case .failure(let error):
                self.onSignUpFailure?(error.localizedDescription)
            }
        }
    }
    
    // 아이디 중복 체크
    func checkUserIDAvailability(userId: String) {
        guard ValidationHelper.isValidUserID(userId) else {
            onUserIDAvailabilityChecked?(invalidUserIDMessage, false)
            return
        }
        
        checkUserIDAvailabilityUseCase.execute(userId: userId) { result in
            switch result {
            case .success:
                self.onUserIDAvailabilityChecked?("사용가능한 아이디입니다.", true)
            case .failure(let error):
                if let nsError = error as NSError?, nsError.code == 409 {
                    self.onUserIDAvailabilityChecked?(self.duplicateUserIDMessage, false)
                } else {
                    self.onUserIDAvailabilityChecked?(error.localizedDescription, false)
                }
            }
        }
    }
    
    // 비밀번호 형식 체크
    func checkPasswordAvailability(password: String) {
        if ValidationHelper.isValidPassword(password) {
            onPasswordFormatError?("사용가능한 비밀번호입니다.", true)
        } else {
            onPasswordFormatError?(invalidPasswordMessage, false)
        }
    }
    
    // 비밀번호 일치체크
    func checkSamePassword(password: String, checkPassword: String) {
        if ValidationHelper.isPasswordSame(password, checkpw: checkPassword) {
            onCheckPasswordFormatError?("비밀번호가 일치힙니다.", true)
        } else {
            onCheckPasswordFormatError?("비밀번호가 일치하지 않습니다.", false)
        }
    }
    
    // 이메일 중복체크
    func checkEmailAvailability(email: String) {
        guard ValidationHelper.isValidEmail(email) else {
            onEmailVerificationCodeSent?(invalidEmailMessage, false)
            return
        }
        
        checkEmailAvailabilityUseCase.execute(email: email) { result in
            switch result {
            case .success:
                self.sendEmailVerificationCode(email: email)
            case .failure(let error):
                if let nsError = error as NSError?, nsError.code == 409 {
                    self.onEmailVerificationCodeSent?(self.duplicateEmailMessage, false)
                } else {
                    self.onEmailVerificationCodeSent?(error.localizedDescription, false)
                }
            }
        }
    }
    
    // 인증코드 전송
    func sendEmailVerificationCode(email: String) {
        sendEmailVerificationCodeUseCase.execute(email: email) { result in
            switch result {
            case .success:
                self.onEmailVerificationCodeSent?("인증코드가 전송되었습니다.", true)
                self.email = email
                self.timerHelper.startTimer()
            case .failure(let error):
                self.onEmailVerificationCodeVerified?(error.localizedDescription, false)
            }
        }
    }
    
    // 인증코드 확인
    func verifyEmailCode(inputCode: String) {
        if timerHelper.timerCount == 0 {
            self.onEmailVerificationCodeVerified?(emailVerificationExpiredMessage, false)
        } else {
            verifyEmailCodeUseCase.execute(email: email, code: inputCode) { result in
                switch result {
                case .success:
                    self.user.email = self.email
                    self.onEmailVerificationCodeVerified?(self.emailVerificationSuccessMessage, true)
                case .failure(let error):
                    self.onEmailVerificationCodeVerified?(error.localizedDescription, false)
                }
            }
        }
    }
    
    // MARK: - Validation Helpers
    
    private func validateSignUpInputs() -> Bool {
        guard let username = user.userName, !username.isEmpty else {
            onSignUpFailure?("이름을 확인해주세요.")
            return false
        }
        
        guard let userId = user.userId, !userId.isEmpty else {
            onSignUpFailure?("아이디를 확인해주세요.")
            return false
        }
        
        guard let email = user.email, !email.isEmpty else {
            onSignUpFailure?("이메일을 확인해주세요.")
            return false
        }
        
        guard ValidationHelper.isValidPassword(password) else {
            onSignUpFailure?("비밀번호를 확인해주세요.")
            return false
        }
        
        guard password == confirmPassword else {
            onSignUpFailure?("비밀번호가 일치하지 않습니다.")
            return false
        }
        
        return true
    }
}
