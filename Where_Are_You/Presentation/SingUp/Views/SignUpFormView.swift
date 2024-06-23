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
        view.backgroundColor = .color234
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
    
    let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이름", textColor: .color51, fontSize: descriptionFontSize)
    
    let userNameTextField = Utilities().inputContainerTextField(withPlaceholder: "이름", fontSize: textFieldFontSize)
    
    let userIDLabel = CustomLabel(UILabel_NotoSans: .medium, text: "아이디", textColor: .color51, fontSize: descriptionFontSize)
    
    let userIDTextField = Utilities().inputContainerTextField(withPlaceholder: "아이디", fontSize: textFieldFontSize)
    
    let userIDCheckButton = CustomButton(title: "중복확인", backgroundColor: .brandColor, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    let userIDErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let passwordLabel = CustomLabel(UILabel_NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: descriptionFontSize)
    
    let passwordTextField = Utilities().inputContainerTextField(withPlaceholder: "비밀번호", fontSize: textFieldFontSize)
    
    let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let checkPasswordTextField = Utilities().inputContainerTextField(withPlaceholder: "비밀번호 확인", fontSize: textFieldFontSize)
    
    let checkPasswordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let emailLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이메일", textColor: .color51, fontSize: descriptionFontSize)
    
    let emailTextField = Utilities().inputContainerTextField(withPlaceholder: "이메일", fontSize: textFieldFontSize)
    
    let emailCheckButton = CustomButton(title: "인증요청", backgroundColor: .brandColor, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let authCodeTextField = Utilities().inputContainerTextField(withPlaceholder: "인증코드", fontSize: textFieldFontSize)
    
    let authCheckButton = CustomButton(title: "확인", backgroundColor: .brandColor, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    var authStack = UIStackView()
    
    let authCodeErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let timer: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let bottomButtonView = BottomButtonView(title: "시작하기")
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        constraints()
        setupAuthStack()
        authStack.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
        }
        
        progressBar.addSubview(colorBar)
        colorBar.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.666)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar).offset(26)
            make.left.equalToSuperview().offset(20)
        }
        
        addSubview(bottomButtonView)
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
    }
    
    func setupAuthStack() {
        let usernameStack = UIStackView(arrangedSubviews: [userNameLabel, userNameTextField])
        usernameStack.axis = .vertical
        
        let idCheckStack = UIStackView(arrangedSubviews: [userIDTextField, userIDCheckButton])
        idCheckStack.axis = .horizontal
        idCheckStack.spacing = 4
        
        let idStack = UIStackView(arrangedSubviews: [userIDLabel, idCheckStack, userIDErrorLabel])
        idStack.axis = .vertical
        
        let passwordEnterStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField, passwordErrorLabel])
        passwordEnterStack.axis = .vertical
        
        let passwordCheckStack = UIStackView(arrangedSubviews: [checkPasswordTextField, checkPasswordErrorLabel])
        passwordCheckStack.axis = .vertical
        
        let emailCheckStack = UIStackView(arrangedSubviews: [emailTextField, emailCheckButton])
        emailCheckStack.axis = .horizontal
        emailCheckStack.spacing = 4
        
        let emailStack = UIStackView(arrangedSubviews: [emailLabel, emailCheckStack, emailErrorLabel])
        emailStack.axis = .vertical
        
        let authCheckStack = UIStackView(arrangedSubviews: [authCodeTextField, authCheckButton])
        authCheckStack.axis = .horizontal
        authCheckStack.spacing = 4
        
        authStack = UIStackView(arrangedSubviews: [authCheckStack, authCodeErrorLabel])
        
        let stack = UIStackView(arrangedSubviews: [usernameStack, idStack, passwordEnterStack, passwordCheckStack, emailStack, authStack])
        stack.axis = .vertical
        stack.spacing = 10
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalTo(titleLabel)
            make.centerX.equalToSuperview()
        }
        
        idCheckStack.addSubview(userIDCheckButton)
        userIDCheckButton.snp.makeConstraints { make in
            make.width.equalTo(stack.snp.width).multipliedBy(0.29)
        }
        
        emailCheckStack.addSubview(emailCheckButton)
        emailCheckButton.snp.makeConstraints { make in
            make.width.equalTo(userIDCheckButton)
        }
        
        authStack.addSubview(authCheckStack)
        authCheckStack.snp.makeConstraints { make in
            make.width.equalTo(userIDTextField)
        }
        
        authCheckStack.addSubview(authCheckButton)
        authCheckButton.snp.makeConstraints { make in
            make.width.equalTo(userIDCheckButton)
        }
        
        authCheckStack.addSubview(timer)
        timer.snp.makeConstraints { make in
            make.centerY.equalTo(authCheckStack)
            make.right.equalTo(authCodeTextField.snp.right).inset(11)
        }
    }
}
