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
    private let appleJoinUseCase: AppleJoinUseCase
    
    var onEmailDuplicate: (([String]) -> Void)?
    var onSignUpSuccess: (() -> Void)?
    var onSignUpButtonState: ((Bool) -> Void)?
    
    var onUserNameValidationMessage: ((String, Bool) -> Void)?
    
    // MARK: - LifeCycle
    init(snsSignUpUseCase: SnsSignUpUseCase,
         checkEmailUseCase: CheckEmailUseCase,
         appleJoinUseCae: AppleJoinUseCase) {
        self.snsSignUpUseCase = snsSignUpUseCase
        self.checkEmailUseCase = checkEmailUseCase
        self.appleJoinUseCase = appleJoinUseCae
    }
    
    // MARK: - Helpers
    func appleJoin(userName: String, code: String) {
        appleJoinUseCase.execute(userName: userName, code: code) { result in
            switch result {
            case .success:
                self.onSignUpSuccess?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
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
}
