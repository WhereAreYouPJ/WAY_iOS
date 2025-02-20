//
//  CheckPasswordView.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/1/2025.
//

import UIKit

class CheckPasswordView: UIView {
    // MARK: - Properties
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP1(text: "계정 삭제를 위해 \n비밀번호를 입력해주세요.", textColor: .black22))
    
    private let passwordTitle = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: " 비밀번호", textColor: .black22))

    let passwordTextField = CustomTextField(placeholder: "비밀번호를 입력해주세요.")
    
    let passwordErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "비밀번호가 맞지 않습니다.", textColor: .error))
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [passwordTitle, passwordTextField, passwordErrorLabel])
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    let deleteButton = TitleButton(title: UIFont.CustomFont.button18(text: "회원 탈퇴하기", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        passwordErrorLabel.isHidden = true
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureViewComponents() {
        addSubview(titleLabel)
        addSubview(stackView)
        addSubview(deleteButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 40))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
    
    func updateLoginButtonState() {
        let isPasswordEntered = !(passwordTextField.text?.isEmpty ?? true)
        
        if isPasswordEntered {
            deleteButton.updateBackgroundColor(.brandMain)
            deleteButton.isEnabled = true
        } else {
            deleteButton.updateBackgroundColor(.blackAC)
            deleteButton.isEnabled = false
        }
    }
}
