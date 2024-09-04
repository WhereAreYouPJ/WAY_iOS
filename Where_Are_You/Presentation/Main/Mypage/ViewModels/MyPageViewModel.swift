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
    let memberSeq = UserDefaultsManager.shared.getMemberSeq()

    var onGetMemberSuccess: ((MemberDetailsResponse) -> Void)?
    var onGetMemberFailure: ((String) -> Void)?
    var onLogoutSuccess: (() -> Void)?

    init(logoutUseCase: LogoutUseCase, memberDetailsUseCase: MemberDetailsUseCase) {
        self.logoutUseCase = logoutUseCase
        self.memberDetailsUseCase = memberDetailsUseCase
    }
    
    func logout() {
        logoutUseCase.execute(request: LogoutBody(memberSeq: memberSeq)) { result in
            switch result {
            case .success:
                self.onLogoutSuccess?()
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func getMemberDetail() {
        memberDetailsUseCase.execute(request: MemberDetailsParameters(memberSeq: memberSeq)) { result in
            switch result {
            case .success(let data):
                print(data)
                self.onGetMemberSuccess?(data)
            case .failure(let error):
                self.onGetMemberFailure?(error.localizedDescription)
            }
        }
    }
}
