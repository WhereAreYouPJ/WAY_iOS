//
//  SearchID.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/5/2024.
//

import UIKit
import SnapKit

// 계정 찾기
class AccountSearchView: UIView {
    // MARK: - Properties
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "온마이웨이에 가입했던 이메일을 \n입력해주세요.", textColor: .black22))
    
    private let emailLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "이메일 주소", textColor: .black22), isPaddingLabel: true)
    
    let emailTextField = CustomTextField(placeholder: "이메일")
    
    let requestAuthButton = TitleButton(title: UIFont.CustomFont.button16(text: "인증요청", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
    private lazy var emailBoxStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, requestAuthButton])
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    let emailErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .black22), isPaddingLabel: true)
    
    private lazy var emailStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailBoxStack, emailErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    let authNumberTextField = CustomTextField(placeholder: "인증코드 입력")
    
    let timer = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "", textColor: .error))
    
    let authNumberCheckButton = TitleButton(title: UIFont.CustomFont.button16(text: "확인", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
    private lazy var authBoxStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authNumberTextField, authNumberCheckButton])
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    let authNumberErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .error), isPaddingLabel: true)
    
    lazy var authStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authBoxStack, authNumberErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailStack, authStack])
        stackView.spacing = 14
        stackView.axis = .vertical
        return stackView
    }()
    
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "확인", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
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
        bottomButtonView.updateBackgroundColor(.color171)
        bottomButtonView.isEnabled = false
        
        emailTextField.keyboardType = .emailAddress
        authNumberTextField.keyboardType = .numberPad
        
        addSubview(titleLabel)
        authNumberTextField.addSubview(timer)
        addSubview(stack)
        addSubview(bottomButtonView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 54))
            make.leading.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 24))
        }
        
        timer.snp.makeConstraints { make in
            make.centerY.equalTo(authNumberTextField)
            make.trailing.equalTo(authNumberTextField.snp.trailing).inset(LayoutAdapter.shared.scale(value: 11))
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 50))
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel)
        }
        
        requestAuthButton.snp.makeConstraints { make in
            make.width.equalTo(LayoutAdapter.shared.scale(value: 91))
        }
        
        authNumberCheckButton.snp.makeConstraints { make in
            make.width.equalTo(requestAuthButton)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
