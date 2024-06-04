//
//  LoginViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

class AccountLoginViewModel {
    private let userUseCase: UserUseCase
    
    var user: User?
    var error: String?
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func login(userID: String, password: String, completion: @escaping () -> Void) {
        userUseCase.login(userID: userID, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                self?.error = error.localizedDescription
            }
            completion()
        }
    }
}
