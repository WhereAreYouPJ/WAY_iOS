//
//  SNSCheckTextView.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/7/2025.
//

import UIKit

class SNSCheckTextView: UIView {
    // MARK: - Properties
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP1(text: "계정 삭제를 위해 \n아래 항목을 입력해주세요.", textColor: .black22))
    
    let checkTextField = CustomTextField(placeholder: "온마이웨이 회원 탈퇴", placeholderColor: UIColor.rgb(red: 190, green: 179, blue: 229))
    
    let checkErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "서버 오류", textColor: .error))
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [checkTextField, checkErrorLabel])
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    let deleteButton = TitleButton(title: UIFont.CustomFont.button18(text: "회원 탈퇴하기", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        checkErrorLabel.isHidden = true
        checkTextField.backgroundColor = UIColor.rgb(red: 249, green: 247, blue: 255)
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
        if checkTextField.text == "온마이웨이 회원 탈퇴" {
            deleteButton.updateBackgroundColor(.brandMain)
            deleteButton.isEnabled = true
        } else {
            deleteButton.updateBackgroundColor(.blackAC)
            deleteButton.isEnabled = false
        }
    }
}
