//
//  SearchPasswordView.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit
import SnapKit

class PasswordResetView: UIView {
    // MARK: - Properties
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "회원님의 비밀번호를 \n재설정 해주세요.", textColor: .black22))
    
    private let passwordLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "비밀번호", textColor: .black22), isPaddingLabel: true)
    
    let resetPasswordTextField = CustomTextField(placeholder: "비밀번호")
    
    let hidePasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.tintColor = .blackAC
        return button
    }()
    
    let resetPasswordDescription = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: " 영문 대소문자로 시작하는 6~20자의 영문 대소문자, 숫자를 포함해 입력해주세요.", textColor: .brandMain), isPaddingLabel: true)
    
    private lazy var resetStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordLabel, resetPasswordTextField, resetPasswordDescription])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    let checkPasswordTextField = CustomTextField(placeholder: "비밀번호 확인")
    
    let hideCheckPasswordButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.tintColor = .blackAC
        return button
    }()
    
    let checkPasswordDescription = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "비밀번호가 일치하지 않습니다.", textColor: .error), isPaddingLabel: true)
    
    lazy var checkStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkPasswordTextField, checkPasswordDescription])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [resetStack, checkStack])
        stackView.spacing = 6
        stackView.axis = .vertical
        return stackView
    }()
    
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "확인", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
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
    
    // MARK: - Helpers
    private func configureViewComponents() {
        resetPasswordTextField.isSecureTextEntry = true
        checkPasswordTextField.isSecureTextEntry = true
        
        addSubview(titleLabel)
        addSubview(stack)
        addSubview(bottomButtonView)
        addSubview(hidePasswordButton)
        addSubview(hideCheckPasswordButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 54))
            make.leading.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 24))
        }
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 50))
        }
        
        hidePasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(resetPasswordTextField)
//            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 20))
            make.width.equalTo(hidePasswordButton.snp.height)
            make.trailing.equalTo(resetPasswordTextField.snp.trailing).inset(LayoutAdapter.shared.scale(value: 12))
        }
        
        hideCheckPasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(checkPasswordTextField)
//            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 20))
            make.width.equalTo(hideCheckPasswordButton.snp.height)
            make.trailing.equalTo(checkPasswordTextField.snp.trailing).inset(LayoutAdapter.shared.scale(value: 12))
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
