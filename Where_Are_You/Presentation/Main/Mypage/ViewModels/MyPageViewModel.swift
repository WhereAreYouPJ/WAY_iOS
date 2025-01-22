//
//  MyPageViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/7/2024.
//

import Foundation
import UIKit

class MyPageViewModel {
    private let logoutUseCase: LogoutUseCase
    private let memberDetailsUseCase: MemberDetailsUseCase
    private let modifyProfileImageUseCase: ModifyProfileImageUseCase
    
    var onGetMemberSuccess: ((MemberDetailsResponse) -> Void)?
    var onProfileImageUploadSuccess: (() -> Void)?
    var onLogoutSuccess: (() -> Void)?

    init(logoutUseCase: LogoutUseCase, memberDetailsUseCase: MemberDetailsUseCase, modifyProfileImageUseCase: ModifyProfileImageUseCase) {
        self.logoutUseCase = logoutUseCase
        self.memberDetailsUseCase = memberDetailsUseCase
        self.modifyProfileImageUseCase = modifyProfileImageUseCase
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
    
    func modifyProfileImage(image: UIImage) {
        modifyProfileImageUseCase.execute(images: image) { result in
            switch result {
            case .success:
                self.onProfileImageUploadSuccess?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
}
