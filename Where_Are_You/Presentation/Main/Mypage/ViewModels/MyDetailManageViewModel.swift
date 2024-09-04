//
//  MyDetailManageViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 27/8/2024.
//

import Foundation

class MyDetailManageViewModel {
    private let memberDetailsUseCase: MemberDetailsUseCase
    
    var onChangeNameSuccess: ((String, String) -> Void)?
    var onChangeNameFailure: ((String) -> Void)?

    init(memberDetailsUseCase: MemberDetailsUseCase) {
        self.memberDetailsUseCase = memberDetailsUseCase
    }
    

}
