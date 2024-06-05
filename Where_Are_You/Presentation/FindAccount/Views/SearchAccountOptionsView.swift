//
//  FindAccount.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/5/2024.
//

import UIKit
import SnapKit

class SearchAccountOptionsView: UIView {
    // MARK: - Properties
    
    let findID = CustomButtonFindAccount(title: "아이디 찾기", description: "가입한 지금어디 계정에 등록된 이메일 정보로 계정을 찾을 수 있어요.")
    let resetPassword = CustomButtonFindAccount(title: "비밀번호 재설정", description: "지금어디 계정에 등록된 아이디 인증을 통해 비밀번호 재설정을 할 수 있어요.")
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(findID)
        findID.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(15)
        }
        
        addSubview(resetPassword)
        resetPassword.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(findID.snp.bottom).offset(16)
            make.left.equalTo(findID)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
