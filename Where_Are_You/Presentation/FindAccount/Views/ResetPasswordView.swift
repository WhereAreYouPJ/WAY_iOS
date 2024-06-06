//
//  SearchPasswordView.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit
import SnapKit

class ResetPasswordView: UIView {
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "회원님의 비밀번호를 재설정해주세요", textColor: .color34, fontSize: 22)
    
    private let passwordLabel = CustomLabel(UILabel_NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: 12)
    
    let resetPasswordTextField = Utilities().inputContainerTextField(withPlaceholder: "새 비밀번호", fontSize: 14)
    
    let resetPasswordDescription: UILabel = {
            let label = UILabel()
            label.textColor = .warningColor
            label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
            return label
    }()
    
    let checkPasswordTextField = Utilities().inputContainerTextField(withPlaceholder: "비밀번호 확인", fontSize: 14)

    let checkPasswordDescription: UILabel = {
            let label = UILabel()
            label.textColor = .warningColor
            label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
            return label
    }()
    
    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func constraints() {
        
    }

}
