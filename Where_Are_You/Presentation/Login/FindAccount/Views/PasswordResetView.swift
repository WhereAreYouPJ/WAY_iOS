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
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "회원님의 비밀번호를 재설정해주세요", textColor: .black22, fontSize: 22)
    
    private let passwordLabel = CustomLabel(UILabel_NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: 12)
    
    let resetPasswordTextField = Utilities.inputContainerTextField(withPlaceholder: "비밀번호")
    
    let resetPasswordDescription: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var resetStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordLabel, resetPasswordTextField, resetPasswordDescription])
        stackView.axis = .vertical
        return stackView
    }()
    
    let checkPasswordTextField = Utilities.inputContainerTextField(withPlaceholder: "비밀번호 확인")
    
    let checkPasswordDescription: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var checkStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkPasswordTextField, checkPasswordDescription])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [resetStack, checkStack])
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    let bottomButtonView = BottomButtonView(title: "확인")
    
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
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.533)
        }
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
