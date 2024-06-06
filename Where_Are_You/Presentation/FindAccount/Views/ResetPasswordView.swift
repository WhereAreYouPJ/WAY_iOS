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
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let checkPasswordTextField = Utilities().inputContainerTextField(withPlaceholder: "비밀번호 확인", fontSize: 14)
    
    let checkPasswordDescription: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let bottomButtonView = BottomButtonView(title: "확인")
    
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.533)
            make.height.equalTo(titleLabel.snp.width).multipliedBy(0.36)
        }
        
        let resetStack = UIStackView(arrangedSubviews: [passwordLabel, resetPasswordTextField, resetPasswordDescription])
        resetStack.axis = .vertical
        
        let checkStack = UIStackView(arrangedSubviews: [checkPasswordTextField, checkPasswordDescription])
        checkStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [resetStack, checkStack])
        stack.spacing = 10
        stack.axis = .vertical
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        resetPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(stack.snp.width).multipliedBy(0.13)
        }
        
        checkPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(resetPasswordTextField)
        }
        
        addSubview(bottomButtonView)
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
    }
    
}
