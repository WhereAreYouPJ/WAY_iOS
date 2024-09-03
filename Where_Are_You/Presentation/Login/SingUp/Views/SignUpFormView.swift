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
        view.backgroundColor = .color235
        return view
    }()
    
    private let colorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightpurple
        view.layer.cornerRadius = 3
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "아래 내용을 작성해주세요", textColor: .color34, fontSize: 22)
    
    private let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이름", textColor: .color51, fontSize: LayoutAdapter.shared.scale(value: 12))
    
    let userNameTextField = Utilities.inputContainerTextField(withPlaceholder: "이름")
    
    let userNameErrorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    // 이름 + 이름tf
    lazy var usernameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, userNameTextField, userNameErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private let emailLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이메일", textColor: .color51, fontSize: LayoutAdapter.shared.scale(value: 12))
    
    let emailTextField = Utilities.inputContainerTextField(withPlaceholder: "이메일")
    
    let emailCheckButton = CustomButton(title: "인증요청", backgroundColor: .brandColor, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
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
    
    let authCodeTextField = Utilities.inputContainerTextField(withPlaceholder: "인증코드")
    
    let timer: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let authCheckButton = CustomButton(title: "확인", backgroundColor: .brandColor, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    // 인증코드tf + 인증코드 확인버튼
    lazy var authCheckStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authCodeTextField, authCheckButton])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    let authCodeErrorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    lazy var authStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authCheckStack, authCodeErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    let passwordLabel = CustomLabel(UILabel_NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: LayoutAdapter.shared.scale(value: 12))
    
    let passwordTextField = Utilities.inputContainerTextField(withPlaceholder: "비밀번호")
    
    let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let checkPasswordTextField = Utilities.inputContainerTextField(withPlaceholder: "비밀번호 확인")
    
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
    
    let bottomButtonView = BottomButtonView(title: "시작하기")
    
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
        bottomButtonView.button.updateBackgroundColor(.color171)
        bottomButtonView.button.isEnabled = false
        
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
            make.leading.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
