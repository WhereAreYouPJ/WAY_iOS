//
//  DeleteMemberViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/1/2025.
//

import Foundation

class DeleteMemberViewModel {
    private let deleteAccountUseCase: DeleteMemberUseCase
    var onDeleteAccount: ((Bool) -> Void)?
    
    init(deleteAccountUseCase: DeleteMemberUseCase) {
        self.deleteAccountUseCase = deleteAccountUseCase
    }
    
    func deleteAccount(password: String, comment: String, loginType: String) {
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
        let request = DeleteMemberBody(memberSeq: memberSeq,
                                       password: password,
                                       comment: comment,
                                       loginType: loginType)
        deleteAccountUseCase.execute(request: request) { result in
            switch result {
            case .success:
                self.onDeleteAccount?(true)
            case .failure(let error):
                print(error.localizedDescription)
                self.onDeleteAccount?(false)
            }
        }
    }
}
