//
//  AccountLogin.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

class AccountLoginView: UIView {
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "로그인하기", textColor: .color34, fontSize: 22)
    
    private let idLabel = CustomLabel(UILabel_NotoSans: .medium, text: "아이디", textColor: .color51, fontSize: 12)
    
    let idTextField = Utilities().inputContainerTextField(withPlaceholder: "아이디를 입력해주세요.", fontSize: textFieldFontSize)
    
    let idErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let passwordLabel = CustomLabel(UILabel_NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: 12)

    let passwordTextField = Utilities().inputContainerTextField(withPlaceholder: "비밀번호를 입력해주세요.", fontSize: textFieldFontSize)
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let loginButton = CustomButton(title: "로그인하기", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
    let findAccountButton = CustomButtonView(text: "계정찾기", weight: .medium, textColor: .color102, fontSize: 14)
    
    let signupButton = Utilities().attributedButton("계정이 없으신가요?", "  가입하기")
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(21)
        }

        let idStack = UIStackView(arrangedSubviews: [idLabel, idTextField, idErrorLabel])
        idStack.axis = .vertical
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField, passwordErrorLabel])
        passwordStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [idStack, passwordStack])
        stack.spacing = 10
        stack.axis = .vertical
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(21)
        }

        addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stack.snp.bottom).offset(30)
            make.left.equalTo(stack.snp.left)
            make.height.equalTo(loginButton.snp.width).multipliedBy(0.145)
        }
        
        addSubview(findAccountButton)
        findAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        
        addSubview(signupButton)
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(findAccountButton.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
