//
//  RegisterViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class RegisterViewModel {
    private let userUseCase: UserUseCase
    
    var user: User?
    var error: String?
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func register(user: User, completion: @escaping () -> Void) {
        userUseCase.register(user: user) { [weak self] result in
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
