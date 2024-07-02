//
//  PasswordResetViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/7/2024.
//

import Foundation

class PasswordResetViewModel {
    
    // MARK: - Properties
    private let resetPasswordUseCase: ResetPasswordUseCase
    
    var userId: String = ""
    
    var onResetPasswordSuccess: (() -> Void)?
    var onResetPasswordFailure: ((String) -> Void)?
    
    init(resetPasswordUseCase: ResetPasswordUseCase) {
        self.resetPasswordUseCase = resetPasswordUseCase
    }
    
    // 이전의 확인받은 userID와 패스워드 체크 패스워드 입력해서 변경하기
    func resetPassword(password: String, checkPassword: String) {
        guard isValidPassword(password) else {
            onResetPasswordFailure?("비밀번호를 확인해주세요.")
            return
        }
        
        guard password == checkPassword else {
            onResetPasswordFailure?("비밀번호가 일치하지 않습니다.")
            return
        }
        
        resetPasswordUseCase.execute(userId: userId, password: password, checkPassword: checkPassword) { [weak self] result in
            switch result {
            case .success():
                self?.onResetPasswordSuccess?()
            case .failure(let error):
                self?.onResetPasswordFailure?(error.localizedDescription)
            }
        }
    }
    
    func isValidPassword(_ pw: String) -> Bool {
        let pwRegex = "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z][A-Za-z0-9]{5,19}$"
        let pwPred = NSPredicate(format: "SELF MATCHES %@", pwRegex)
        return pwPred.evaluate(with: pw)
    }
    
    func isPasswordSame(_ pw: String, checkpw: String) -> Bool {
        return pw == checkpw
    }
}
