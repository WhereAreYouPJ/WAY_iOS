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
    
    private let emailLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이메일 주소", textColor: .color51, fontSize: 12)
    
    let emailTextField = Utilities.inputContainerTextField(withPlaceholder: "이메일을 입력해주세요.", fontSize: textFieldFontSize)
    
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    lazy var idStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailLabel, emailTextField, emailErrorLabel])
        stack.axis = .vertical
        return stack
    }()
    
    private let passwordLabel = CustomLabel(UILabel_NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: 12)
    
    let passwordTextField = Utilities.inputContainerTextField(withPlaceholder: "비밀번호를 입력해주세요.", fontSize: textFieldFontSize)
    
    lazy var passwordStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField])
        stack.axis = .vertical
        return stack
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [idStack, passwordStack])
        stack.spacing = 10
        stack.axis = .vertical
        return stack
    }()
    
    let loginButton = CustomButton(title: "로그인하기", backgroundColor: .color171, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
    let findAccountButton = CustomButtonView(text: "계정찾기", weight: .medium, textColor: .color102, fontSize: 14)
    
    let signupButton = Utilities.attributedButton("계정이 없으신가요?", "  가입하기")
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
        updateLoginButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func configureViewComponents() {
        emailTextField.keyboardType = .emailAddress
        addSubview(titleLabel)
        addSubview(stack)
        addSubview(loginButton)
        addSubview(findAccountButton)
        addSubview(signupButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.leading.equalToSuperview().offset(21)
        }
        
        stack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(21)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stack.snp.bottom).offset(30)
            make.leading.equalTo(stack.snp.leading)
            make.height.equalTo(loginButton.snp.width).multipliedBy(0.145)
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(findAccountButton.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
    }
    
    func updateLoginButtonState() {
        let isUserIdEntered = !(emailTextField.text?.isEmpty ?? true)
        let isPasswordEntered = !(passwordTextField.text?.isEmpty ?? true)
        
        if isUserIdEntered && isPasswordEntered {
            loginButton.updateBackgroundColor(.brandColor)
            loginButton.isEnabled = true
        } else {
            loginButton.updateBackgroundColor(.color171)
            loginButton.isEnabled = false
        }
    }
}
