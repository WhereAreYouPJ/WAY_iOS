//
//  SocialSignUpViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/2/2025.
//

import Foundation

class SocialSignUpViewModel {
    
    // MARK: - Properties
    private let snsSignUpUseCase: SnsSignUpUseCase
    private let checkEmailUseCase: CheckEmailUseCase

    var signUpBody = MemberSnsBody()
    
    var onEmailDuplicate: (([String]) -> Void)?
    var onSignUpSuccess: (() -> Void)?
    var onSignUpButtonState: ((Bool) -> Void)?
    
    var onUserNameValidationMessage: ((String, Bool) -> Void)?
    
    // MARK: - LifeCycle
    init(snsSignUpUseCase: SnsSignUpUseCase,
         checkEmailUseCase: CheckEmailUseCase) {
        self.snsSignUpUseCase = snsSignUpUseCase
        self.checkEmailUseCase = checkEmailUseCase
    }
    
    // MARK: - Helpers
    func signUp() {
        print(signUpBody)
        snsSignUpUseCase.execute(request: signUpBody) { result in
            switch result {
            case .success:
                self.onSignUpSuccess?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
    
    // 이메일 중복체크
    func checkEmailAvailability(email: String) {
        checkEmailUseCase.execute(email: email) { result in
            switch result {
            case .success(let data):
                if data.type.isEmpty {
                    self.signUp()
                } else {
                    self.onEmailDuplicate?(data.type)
                }
            case .failure(let error):
                // 이메일 중복된게 없으니 바로 회원가입 화면으로 이동
                print(error.localizedDescription)
            }
        }
    }
}
