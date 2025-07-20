//
//  LoginViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

class AccountLoginViewModel {
    
    private let accountLoginUseCase: AccountLoginUseCase
    private let appleLoginUseCase: AppleLoginUseCase

    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String, Bool) -> Void)?
    var onAppleLoginState: ((Bool, String) -> Void)?

    init(accountLoginUseCase: AccountLoginUseCase,
         appleLoginUseCase: AppleLoginUseCase
    ) {
        self.accountLoginUseCase = accountLoginUseCase
        self.appleLoginUseCase = appleLoginUseCase
    }
    
    func login(email: String, password: String) {
        print("🔐FCM Token : \(UserDefaultsManager.shared.getFcmToken())")
        let fcmToken = UserDefaultsManager.shared.getFcmToken()
        accountLoginUseCase.execute(request: LoginBody(email: email, password: password, fcmToken: fcmToken, loginType: "normal")) { result in
            switch result {
            case .success:
                self.onLoginSuccess?()
            case .failure(let error):
                if let apiError = error as? APIError {
                    self.onLoginFailure?(apiError.localizedDescription, false)
                }
            }
        }
    }
    
    // 성공시 mainviewcontroller로 이동
    // 실패시 agreeTermViewcontroller로 이동해서 회원가입 진행
    func appleLogin(code: String) {
        let fcmToken = UserDefaultsManager.shared.getFcmToken()
        print("code: \(code), fcmToken: \(fcmToken)")
        appleLoginUseCase.execute(code: code, fcmToken: fcmToken) { result in
            switch result {
            case .success:
                self.onAppleLoginState?(true, "")
            case .failure:
                self.onAppleLoginState?(false, code)
            }
        }
    }

    private func performLogin(email: String, password: String, fcmToken: String) {
        print("🔐Login with FCM Token: \(fcmToken)")
        accountLoginUseCase.execute(request: LoginBody(email: email, password: password, fcmToken: fcmToken, loginType: "normal")) { result in
            // 기존 코드와 동일
        }
    }
}
