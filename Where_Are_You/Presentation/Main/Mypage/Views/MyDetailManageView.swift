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
    
    private let userNameLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "이름", textColor: .black22), isPaddingLabel: true)
    
    var userNameTextField = CustomTextField(placeholder: "")
    
    let userNameErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "최소 1자 이상 입력해 주세요.", textColor: .error))
    
    lazy var userNameStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, userNameTextField, userNameErrorLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let emailLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "이메일 주소", textColor: .black22), isPaddingLabel: true)
        
    var emailTextfield = CustomTextField(placeholder: "")
    
    lazy var emailStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailTextfield])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    let updateDetailButton = TitleButton(title: UIFont.CustomFont.button18(text: "확인", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
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
        addSubview(userNameStack)
        addSubview(emailStack)
        addSubview(updateDetailButton)
        addSubview(modifyButton)
        userNameErrorLabel.isHidden = true
        modifyButton.isHidden = true
        updateDetailButton.isEnabled = false
    }
    
    private func setupConstraints() {
        modifyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.top.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 40))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 180))
        }
        
        userNameStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        emailStack.snp.makeConstraints { make in
            make.top.equalTo(userNameStack.snp.bottom).offset(LayoutAdapter.shared.scale(value: 20))
            make.leading.trailing.equalTo(userNameStack)
        }
        
        updateDetailButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
