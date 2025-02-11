//
//  SignUpFormView.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/6/2024.
//

import UIKit
import SnapKit

class SignUpFormView: UIView {
    // MARK: - Properties
    
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .blackF0
        return view
    }()
    
    private let colorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .brandMain
        view.layer.cornerRadius = 3
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "아래 내용을 작성해주세요", textColor: .black22))
    
    private let userNameLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "이름", textColor: .black22))
    
    let userNameTextField = CustomTextField(placeholder: "이름")
    
    let userNameErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .error))
    
    // 이름 + 이름tf
    lazy var usernameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, userNameTextField, userNameErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private let emailLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "이메일", textColor: .black22))
    
    let emailTextField = CustomTextField(placeholder: "이메일")
    
    let emailCheckButton = TitleButton(title: UIFont.CustomFont.button16(text: "인증요청", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
    let emailErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .error))
    
    // 이메일 + 이메일tf + 이메일 중복버튼 + description
    lazy var emailCheckStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, emailCheckButton])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var emailStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailCheckStack, emailErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    let authCodeTextField = CustomTextField(placeholder: "인증코드")
    
    let timer = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .error))
    
    let authCheckButton = TitleButton(title: UIFont.CustomFont.button16(text: "확인", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
    // 인증코드tf + 인증코드 확인버튼
    lazy var authCheckStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authCodeTextField, authCheckButton])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    let authCodeErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .error))
    
    lazy var authStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authCheckStack, authCodeErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    let passwordLabel =  StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "비밀번호", textColor: .black22))
    
    let passwordTextField = CustomTextField(placeholder: "비밀번호")
    
    let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let checkPasswordTextField = CustomTextField(placeholder: "비밀번호 확인")
    
    let checkPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // 비밀번호 + 비밀번호tf + description + 비밀번호 일치tf + description
    lazy var passwordEnterStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField, passwordErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var passwordCheckStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkPasswordTextField, checkPasswordErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameStack, emailStack, authStack, passwordEnterStack, passwordCheckStack])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "시작하기", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViewComponents() {
        authStack.isHidden = true
        passwordTextField.isSecureTextEntry = true
        checkPasswordTextField.isSecureTextEntry = true
        bottomButtonView.updateBackgroundColor(.color171)
        bottomButtonView.isEnabled = false
        
        emailTextField.keyboardType = .emailAddress
        authCodeTextField.keyboardType = .numberPad
        
        addSubview(progressBar)
        progressBar.addSubview(colorBar)
        addSubview(titleLabel)
        addSubview(bottomButtonView)
        addSubview(stack)
        authCodeTextField.addSubview(timer)
    }
    
    private func setupConstraints() {
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
        }
        
        colorBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.666)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar).offset(30)
            make.leading.equalToSuperview().offset(15)
        }
        
        emailCheckButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.29)
        }
        
        timer.snp.makeConstraints { make in
            make.centerY.equalTo(authCodeTextField)
            make.trailing.equalTo(authCodeTextField.snp.trailing).inset(11)
        }
        
        authCheckStack.snp.makeConstraints { make in
            make.width.equalTo(emailCheckStack)
        }

        authCheckButton.snp.makeConstraints { make in
            make.width.equalTo(emailCheckButton)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualTo(bottomButtonView.snp.top).offset(-20)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
