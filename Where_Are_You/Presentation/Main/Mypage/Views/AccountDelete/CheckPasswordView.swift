//
//  CheckPasswordView.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/1/2025.
//

import UIKit

class CheckPasswordView: UIView {
    // MARK: - Properties
    private let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "계정 삭제를 위해 \n비밀번호를 입력해주세요.", textColor: .black, fontSize: 20)
    
    private let passwordTitle = CustomLabel(UILabel_NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: 12)

    let passwordTextField = CustomTextField(placeholder: "비밀번호")
//    Utilities.inputContainerTextField(withPlaceholder: "비밀번호") // 로그인에서 참고하기
    
    let passwordErrorLabel = CustomLabel(UILabel_NotoSans: .medium, text: "비밀번호가 맞지 않습니다.", textColor: .error, fontSize: 12)
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [passwordTitle, passwordTextField, passwordErrorLabel])
        sv.axis = .vertical
        sv.spacing = 2
        return sv
    }()
    
    let deleteButton = CustomButton(title: "회원 탈퇴하기", backgroundColor: .color171, titleColor: .white, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
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
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 30))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 30))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 68))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
    }
    
    func updateLoginButtonState() {
        let isPasswordEntered = !(passwordTextField.text?.isEmpty ?? true)
        
        if isPasswordEntered {
            deleteButton.updateBackgroundColor(.brandColor)
            deleteButton.isEnabled = true
        } else {
            deleteButton.updateBackgroundColor(.color171)
            deleteButton.isEnabled = false
        }
    }
}
