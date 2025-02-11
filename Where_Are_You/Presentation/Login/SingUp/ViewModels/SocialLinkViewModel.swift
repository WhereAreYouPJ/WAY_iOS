//
//  SocialLinkViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/2/2025.
//

import Foundation

class SocialLinkViewModel {
    private let accountLinkUseCase: AccountLinkUseCase
    
    var accountLinkBody = MemberSnsBody()
    
    var onSignUpSuccess: (() -> Void)?
    // MARK: - LifeCycle
    init(accountLinkUseCase: AccountLinkUseCase) {
        self.accountLinkUseCase = accountLinkUseCase
    }
    
    // MARK: - Helpers
    func linkAccount(userName: String, email: String, password: String, loginType: String) {
        accountLinkUseCase.execute(request: MemberSnsBody(userName: userName,
                                                          email: email,
                                                          password: password,
                                                          loginType: loginType,
                                                          fcmToken: UserDefaultsManager.shared.getFcmToken())) { result in
            switch result {
            case .success:
                self.onSignUpSuccess?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
