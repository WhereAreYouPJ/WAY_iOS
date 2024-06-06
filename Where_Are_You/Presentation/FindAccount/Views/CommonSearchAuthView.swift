//
//  SearchID.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/5/2024.
//

import UIKit
import SnapKit

// 아이디 찾기, 비밀번호 찾기 뷰
class SearchAuthView: UIView {
    // MARK: - Properties
    
    var titleLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .bold, text: "지금어디 가입 정보로 아이디를 확인하세요", textColor: .color34, fontSize: 22)
    
    var emailLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이메일 주소", textColor: .color51, fontSize: 12)
    
    let emailTextField = Utilities().inputContainerTextField(withPlaceholder: "이메일", fontSize: 14)
    
    let requestAuthButton = CustomButton(title: "인증요청", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let authNumberTextField = Utilities().inputContainerTextField(withPlaceholder: "인증코드 입력", fontSize: 14)
    
    private let timer: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
        label.adjustsFontForContentSizeCategory = true
        label.text = "4:59"
        return label
    }()
    
    let authNumberCheckButton = CustomButton(title: "확인", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    private let authNumberErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let bottomContainerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.color221.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let bottomConfirmButton = CustomButton(title: "확인", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.55)
        }
        
        let emailBoxStack = UIStackView(arrangedSubviews: [emailTextField, requestAuthButton])
        emailBoxStack.spacing = 4
        emailBoxStack.axis = .horizontal
        
        let emailStack = UIStackView(arrangedSubviews: [emailLabel, emailBoxStack, emailErrorLabel])
        emailStack.axis = .vertical
        
        let authBoxStack = UIStackView(arrangedSubviews: [authNumberTextField, authNumberCheckButton])
        authBoxStack.spacing = 4
        authBoxStack.axis = .horizontal
        
        authNumberTextField.addSubview(timer)
        timer.snp.makeConstraints { make in
            make.centerY.equalTo(authNumberTextField)
            make.right.equalTo(authNumberTextField.snp.right).inset(11)
        }
        
        let authStack = UIStackView(arrangedSubviews: [authBoxStack, authNumberErrorLabel])
        authStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [emailStack, authStack])
        stack.spacing = 10
        stack.axis = .vertical
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalTo(titleLabel)
        }
        
        emailBoxStack.addSubview(requestAuthButton)
        requestAuthButton.snp.makeConstraints { make in
            make.width.equalTo(stack).multipliedBy(0.29)
            make.height.equalTo(stack.snp.width).multipliedBy(0.12)
        }
        
        authBoxStack.addSubview(authNumberCheckButton)
        authNumberCheckButton.snp.makeConstraints { make in
            make.width.equalTo(requestAuthButton)
            make.height.equalTo(requestAuthButton)
        }
        
        addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
        
        bottomContainerView.addSubview(bottomConfirmButton)
        bottomConfirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(bottomContainerView)
            make.top.equalTo(bottomContainerView.snp.top).offset(12)
            make.width.equalTo(stack)
            make.height.equalTo(stack.snp.width).multipliedBy(0.145)
        }
    }
}
