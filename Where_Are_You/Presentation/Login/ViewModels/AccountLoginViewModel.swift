//
//  LoginViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import Foundation

class AccountLoginViewModel {
    
    func login(userId: String, password: String) {
        UserDefaults.standard.isLoggedIn = true
    }
}
