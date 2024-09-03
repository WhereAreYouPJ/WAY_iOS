//
//  MyPageViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/7/2024.
//

import Foundation

class MyPageViewModel {
    private let logoutUseCase: LogoutUseCase
    
    var onLogoutSuccess: (() -> Void)?

    init(logoutUseCase: LogoutUseCase) {
        self.logoutUseCase = logoutUseCase
    }
    
    func logout() {
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
        logoutUseCase.execute(request: LogoutBody(memberSeq: memberSeq)) { result in
            if case .success = result {
                self.onLogoutSuccess?()
            } else {
                print("로그아웃 실패: \(result)")
            }
        }
    }
}
