//
//  MyPageViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/7/2024.
//

import Foundation

class MyPageViewModel {
    private let logoutUseCase: LogoutUseCase
    private let memberDetailsUseCase: MemberDetailsUseCase
    
    var onGetMemberSuccess: ((MemberDetailsResponse) -> Void)?
    var onLogoutSuccess: (() -> Void)?

    init(logoutUseCase: LogoutUseCase, memberDetailsUseCase: MemberDetailsUseCase) {
        self.logoutUseCase = logoutUseCase
        self.memberDetailsUseCase = memberDetailsUseCase
    }
    
    func logout() {
        logoutUseCase.execute { result in
            switch result {
            case .success:
                self.onLogoutSuccess?()
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func memberDetails() {
        memberDetailsUseCase.execute { result in
            switch result {
            case .success(let data):
                self.onGetMemberSuccess?(data)
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}
