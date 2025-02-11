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
    let scrollView = UIScrollView()
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "로그인하기", textColor: .black22))
    
    private let emailLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: " 이메일 주소", textColor: .black22))
    
    let emailTextField = CustomTextField(placeholder: "이메일을 입력해주세요.")
    
    let emailErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .error))
    
    lazy var idStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailLabel, emailTextField, emailErrorLabel])
        stack.axis = .vertical
        stack.spacing = LayoutAdapter.shared.scale(value: 4)
        return stack
    }()
    
    private let passwordLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: " 비밀번호", textColor: .black22))
    
    let passwordTextField = CustomTextField(placeholder: "비밀번호를 입력해주세요.")
    
    let passwordErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .error))

    lazy var passwordStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField, passwordErrorLabel])
        stack.axis = .vertical
        stack.spacing = LayoutAdapter.shared.scale(value: 4)
        return stack
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [idStack, passwordStack])
        stack.spacing = LayoutAdapter.shared.scale(value: 14)
        stack.axis = .vertical
        return stack
    }()
    
    let loginButton = TitleButton(title: UIFont.CustomFont.button18(text: "로그인하기", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    let findAccountButton = StandardButton(text: UIFont.CustomFont.bodyP4(text: "계정찾기", textColor: .black66))
    
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
        addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(stack)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(findAccountButton)
        scrollView.addSubview(signupButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 54))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        stack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stack.snp.bottom).offset(LayoutAdapter.shared.scale(value: 68))
            make.leading.equalTo(stack.snp.leading)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(LayoutAdapter.shared.scale(value: 31))
            make.centerX.equalToSuperview()
        }
        
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(findAccountButton.snp.bottom).offset(LayoutAdapter.shared.scale(value: 20))
            make.centerX.equalToSuperview()
        }
    }
    
    func updateLoginButtonState() {
        let isUserIdEntered = !(emailTextField.text?.isEmpty ?? true)
        let isPasswordEntered = !(passwordTextField.text?.isEmpty ?? true)
        
        if isUserIdEntered && isPasswordEntered {
            loginButton.updateBackgroundColor(.brandMain)
            loginButton.isEnabled = true
        } else {
            loginButton.updateBackgroundColor(.blackAC)
            loginButton.isEnabled = false
        }
    }
}
