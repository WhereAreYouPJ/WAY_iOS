//
//  FindAccountViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class FindAccountViewModel {
    private let userUseCase: UserUseCase
    
    var accountID: String?
    var error: String?
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func findAccount(email: String, completion: @escaping () -> Void) {
        userUseCase.findAccount(email: email) { [weak self] result in
            switch result {
            case .success(let accountID):
                self?.accountID = accountID
            case .failure(let error):
                self?.error = error.localizedDescription
            }
            completion()
        }
    }
}
