//
//  RegisterViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class SignUpViewModel {
    private let signUpUseCase: SignUpUseCase
    private let checkUserIDAvailabilityUseCase: CheckUserIDAvailabilityUseCase
    private let checkEmailAvailabilityUseCase: CheckEmailAvailabilityUseCase
    private let sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase
    
    // Input
    var userName: String = ""
    var userID: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var email: String = ""
    var verificationCode: String = ""
    
    // Output
    var onSignUpSuccess: (() -> Void)?
    var onSignUpFailure: ((String) -> Void)?
    var onUserIDAvailabilityChecked: ((String,  Bool) -> Void)?
    var onEmailAvailabilityChecked: ((String) -> Void)?
    var onEmailVerificationCodeSent: ((String) -> Void)?
    var onEmailVerificationCodeVerified: ((String) -> Void)?
    var onEmailFormatError: ((String) -> Void)?
    
    init(signUpUseCase: SignUpUseCase,
         checkUserIDAvailabilityUseCase: CheckUserIDAvailabilityUseCase,
         checkEmailAvailabilityUseCase: CheckEmailAvailabilityUseCase,
         sendEmailVerificationCodeUseCase: SendEmailVerificationCodeUseCase) {
        self.signUpUseCase = signUpUseCase
        self.checkUserIDAvailabilityUseCase = checkUserIDAvailabilityUseCase
        self.checkEmailAvailabilityUseCase = checkEmailAvailabilityUseCase
        self.sendEmailVerificationCodeUseCase = sendEmailVerificationCodeUseCase
    }
    
    func signUp() {
        guard password == confirmPassword else {
            onSignUpFailure?("패스워드가 일치하지 않습니다.")
            return
        }
        
        let request = SignUpRequestModel(userName: userName, userID: userID, password: password, email: email)
        signUpUseCase.execute(request: request) { result in
            switch result {
            case .success:
                self.onSignUpSuccess?()
            case .failure(let error):
                self.onSignUpFailure?(error.localizedDescription)
            }
        }
    }
    
    func checkUserIDAvailability() {
        checkUserIDAvailabilityUseCase.execute(userID: userID) { result in
            switch result {
            case .success(let isAvailable):
                let message = isAvailable ? "사용가능한 아이디입니다." : "중복된 아이디입니다."
                self.onUserIDAvailabilityChecked?(message, isAvailable)
            case .failure(let error):
                self.onUserIDAvailabilityChecked?(error.localizedDescription, false)
            }
        }
    }
    
    func checkEmailAvailability() {
        checkEmailAvailabilityUseCase.execute(email: email) { result in
            switch result {
            case .success(let isAvailable):
                let message = isAvailable ? "인증코드가 전송되었습니다." : "중복된 이메일입니다."
                self.onEmailAvailabilityChecked?(message)
            case .failure(let error):
                self.onEmailAvailabilityChecked?(error.localizedDescription)
            }
        }
    }
    
    func sendEmailVerificationCode() {
        guard isValidEmail(email) else {
            onEmailFormatError?("유효하지 않은 이메일 형식입니다.")
            return
        }
        
        checkEmailAvailabilityUseCase.execute(email: email) { result in
            switch result {
            case .success(let isAvailable):
                if isAvailable {
                    self.sendEmailVerificationCodeUseCase.execute(email: self.email) { result in
                        switch result {
                        case .success:
                            self.onEmailVerificationCodeSent?("인증코드가 전송되었습니다.")
                        case .failure(let error):
                            self.onSignUpFailure?(error.localizedDescription)
                        }
                    }
                } else {
                    self.onSignUpFailure?("이미 존재하는 이메일입니다.")
                }
            case .failure(let error):
                self.onSignUpFailure?(error.localizedDescription)
            }
        }
    }
    
    func verifyEmailCode(inputCode: String) {
        if inputCode == self.verificationCode {
            self.onEmailVerificationCodeVerified?("인증코드가 확인되었습니다.")
        } else {
            self.onSignUpFailure?("인증코드가 일치하지 않습니다.")
        }
    }
    
    private func isValidID(_ id: String) -> Bool {
        return false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
