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
    func signUp(userName: String, email: String, password: String, loginType: String) {
        snsSignUpUseCase.execute(request: MemberSnsBody(userName: userName, email: email, password: password, loginType: loginType, fcmToken: UserDefaultsManager.shared.getFcmToken())) { result in
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
        } else {
            onUserNameValidationMessage?(invalidUserNameMessage, false)
        }
    }
    
    // 이메일 중복체크
    func checkEmailAvailability(userName: String, email: String, password: String, loginType: String) {
        checkEmailUseCase.execute(email: email) { result in
            switch result {
            case .success(let data):
                if data.type.isEmpty {
                    self.signUp(userName: userName, email: email, password: password, loginType: loginType)
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
