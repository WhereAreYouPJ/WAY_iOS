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
        accountLoginUseCase.execute(request: LoginBody(email: email, password: password)) { result in
            switch result {
            case .success:
                self.onLoginSuccess?()
            case .failure:
                self.onLoginFailure?("입력한 정보를 다시 확인해주세요.", false)
            }
        }
    }
}
