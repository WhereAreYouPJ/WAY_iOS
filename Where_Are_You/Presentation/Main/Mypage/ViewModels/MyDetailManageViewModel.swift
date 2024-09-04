//
//  MyDetailManageViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 27/8/2024.
//

import Foundation

class MyDetailManageViewModel {
    private let modifyUserNameUseCase: ModifyUserNameUseCase
    
    var onChangeNameSuccess: (() -> Void)?
    var onChangeNameFailure: ((String) -> Void)?
    var onUserNameValidationMessage: ((Bool) -> Void)?

    init(modifyUserNameUseCase: ModifyUserNameUseCase) {
        self.modifyUserNameUseCase = modifyUserNameUseCase
    }
    
    // 이름 형식 체크
    func checkUserNameValidation(userName: String) {
        if ValidationHelper.isValidUserName(userName) {
            onUserNameValidationMessage?(true)
        } else {
            onUserNameValidationMessage?(false)
        }
    }
    
    // 수정하기
    func modifyUserName(userName: String) {
        modifyUserNameUseCase.execute(userName: userName) { result in
            switch result {
            case .success:
                self.onChangeNameSuccess?()
            case .failure(let error):
                self.onChangeNameFailure?(error.localizedDescription)
            }
        }
    }
}
