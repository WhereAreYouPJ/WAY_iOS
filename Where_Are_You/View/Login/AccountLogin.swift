//
//  AccountLogin.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

class AccountLogin: UIView {
    // MARK: - Properties
    
    private let titleLabel: UIView = {
        let label = Utilities().createLabel(NotoSans: .bold, text: "로그인하기", textColor: .color34, fontSize: 22)
        let view = Utilities().inputContainerView(label: label)
        return view
    }()
    
    private let idLabel: UIView = {
        let label = Utilities().createLabel(NotoSans: .medium, text: "아이디", textColor: .color51, fontSize: 12)
        let view = Utilities().inputContainerView(label: label)
        return view
    }()
    
    private let idTextField: UIView = {
        let tf = Utilities().textField(withPlaceholder: "아이디를 입력해주세요.")
        let view = Utilities().inputContainerView(textField: tf)
        return view
    }()
    
    private let idErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        return label
    }()
    
    private let passwordLabel: UIView = {
        let label = Utilities().createLabel(NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: 12)
        let view = Utilities().inputContainerView(label: label)
        return view
    }()
    
    private let passwordTextField: UIView = {
        let tf = Utilities().textField(withPlaceholder: "비밀번호를 입력해주세요.")
        let view = Utilities().inputContainerView(textField: tf)
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return view
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        return label
    }()
    
    let loginButton = CustomButton(title: "로그인하기", backgroundColor: .brancColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
    let findAccountButton = CustomButtonView(text: "계정찾기", weight: .medium, textColor: .color102, fontSize: 14)
    
    let signupButton: UIButton = {
        let button = Utilities().attributedButton("계정이 없으신가요?", "  가입하기")
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(21)
        }

        let idStack = UIStackView(arrangedSubviews: [idLabel, idTextField, idErrorLabel])
        idStack.axis = .vertical
        
        idTextField.snp.makeConstraints { make in
            make.height.equalTo(self.snp.height).multipliedBy(0.5)
        }
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField, passwordErrorLabel])
        passwordStack.axis = .vertical
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(idTextField.snp.height)
        }
        
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
