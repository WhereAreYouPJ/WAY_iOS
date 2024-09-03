//
//  MyDetailManageViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 27/8/2024.
//

import Foundation

class MyDetailManageViewModel {
    private let memberDetailsUseCase: MemberDetailsUseCase
    
    var onGetMemberSuccess: ((String, String) -> Void)?
    var onGetMemberFailure: ((String) -> Void)?

    init(memberDetailsUseCase: MemberDetailsUseCase) {
        self.memberDetailsUseCase = memberDetailsUseCase
    }
    
    func getMemberDetail() {
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
        memberDetailsUseCase.execute(request: MemberDetailsParameters(memberSeq: memberSeq)) { result in
            switch result {
            case .success(let data):
                self.onGetMemberSuccess?(data.userName, data.email)
            case .failure(let error):
                self.onGetMemberFailure?(error.localizedDescription)
            }
        }
    }
}
