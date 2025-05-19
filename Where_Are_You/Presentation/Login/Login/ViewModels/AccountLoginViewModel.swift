//
//  LoginViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

class AccountLoginViewModel {
    
    private let accountLoginUseCase: AccountLoginUseCase
    
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String, Bool) -> Void)?
    
    init(accountLoginUseCase: AccountLoginUseCase) {
        self.accountLoginUseCase = accountLoginUseCase
    }   
    
    func login(email: String, password: String) {
        print("🔐FCM Token : \(UserDefaultsManager.shared.getFcmToken())")
        accountLoginUseCase.execute(request: LoginBody(email: email, password: password, fcmToken: UserDefaultsManager.shared.getFcmToken(), loginType: "normal")) { result in
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
    
//    func login(email: String, password: String) {
//        let fcmToken = UserDefaultsManager.shared.getFcmToken()
//        
//        // FCM 토큰이 비어있는 경우 토큰을 받을 때까지 잠시 대기
//        if fcmToken.isEmpty {
//            // 최대 3초까지만 대기하는 타이머 구현
//            var attempts = 0
//            let checkTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
//                guard let self = self else { timer.invalidate(); return }
//                
//                let currentToken = UserDefaultsManager.shared.getFcmToken()
//                attempts += 1
//                
//                if !currentToken.isEmpty || attempts >= 6 { // 3초 (0.5초 * 6)
//                    timer.invalidate()
//                    // 토큰이 있거나 최대 시도 횟수에 도달하면 로그인 진행
//                    let finalToken = currentToken.isEmpty ? "token_unavailable" : currentToken
//                    self.performLogin(email: email, password: password, fcmToken: finalToken)
//                }
//            }
//            checkTimer.fire()
//        } else {
//            performLogin(email: email, password: password, fcmToken: fcmToken)
//        }
//    }

    private func performLogin(email: String, password: String, fcmToken: String) {
        print("🔐Login with FCM Token: \(fcmToken)")
        accountLoginUseCase.execute(request: LoginBody(email: email, password: password, fcmToken: fcmToken, loginType: "normal")) { result in
            // 기존 코드와 동일
        }
    }
}
