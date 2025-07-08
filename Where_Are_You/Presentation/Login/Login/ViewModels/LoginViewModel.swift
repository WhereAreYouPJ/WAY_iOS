//
//  LoginViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.07.25.
//

import Foundation

class LoginViewModel {
    private let kakaoLoginUseCase: KakaoLoginUseCase
    
    var onLoginResult: ((Result<Void, Error>) -> Void)?
    var onNeedKakaoSignup: ((String) -> Void)?  // 카카오 회원가입 필요할 때 호출
    
    init(kakaoLoginUseCase: KakaoLoginUseCase) {
        self.kakaoLoginUseCase = kakaoLoginUseCase
    }
    
    func kakaoLogin(authCode: String) {
        let fcmToken = UserDefaultsManager.shared.getFcmToken()
        
        kakaoLoginUseCase.execute(request: KakaoLoginBody(code: authCode, fcmToken: fcmToken)) { result in
            switch result {
            case .success:
                self.onLoginResult?(.success(()))
            case .failure(let error):
                if let apiError = error as? APIError, case .kakaoLoginError = apiError {
                    print("🚀 카카오 회원가입이 필요합니다 (KN007)")
                    self.onNeedKakaoSignup?(authCode)
                } else {
                    self.onLoginResult?(.failure(error)) // 다른 에러인 경우
                }
            }
        }
    }
}
