//
//  MyDetailManageView.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/8/2024.
//

import UIKit

class MyDetailManageView: UIView {
    // MARK: - Properties
    let modifyButton = CustomOptionButtonView(title: "수정하기")
    
    let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이름", textColor: .color51, fontSize: LayoutAdapter.shared.scale(value: 12))
    
    let userNameTextField = CustomTextField(placeholder: "")
    
    let userNameErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "최소 1자 이상 입력해 주세요.", textColor: .error))
    
    lazy var userNameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameTextField, userNameErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    let emailLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이메일 주소", textColor: .color51, fontSize: LayoutAdapter.shared.scale(value: 12))
    
    let emailTextfield =  CustomTextField(placeholder: "")
    
    let updateDetailButton = CustomButton(title: "수정하기", backgroundColor: .color171, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 18)))
    
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
        addSubview(userNameLabel)
        addSubview(userNameStack)
        addSubview(emailLabel)
        addSubview(emailTextfield)
        addSubview(updateDetailButton)
        addSubview(modifyButton)
        userNameErrorLabel.isHidden = true
        modifyButton.isHidden = true
    }
    
    private func setupConstraints() {
        modifyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.top.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 38))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 160))
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 34))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        userNameStack.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        userNameTextField.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 44))
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameStack.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.leading.equalTo(userNameLabel)
        }
        
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom)
            make.leading.trailing.equalTo(userNameTextField)
            make.height.equalTo(userNameTextField)
        }
        
        updateDetailButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.bottom.equalTo(safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
    }
}
