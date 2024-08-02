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
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "지금어디에 가입했던 이메일을 입력해주세요.", textColor: .color34, fontSize: 22)
    
    private let emailLabel = CustomLabel(UILabel_NotoSans: .medium, text: "이메일 주소", textColor: .color51, fontSize: 12)
    
    // TODO: 커스텀 텍스트필드로 수정이 가능한지 체크하기
    let emailTextField = Utilities().inputContainerTextField(withPlaceholder: "이메일", fontSize: textFieldFontSize)
    
    let requestAuthButton = CustomButton(title: "인증요청", backgroundColor: .brandColor, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    private lazy var emailBoxStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, requestAuthButton])
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var emailStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailBoxStack, emailErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    // TODO: 커스텀 텍스트필드로 수정이 가능한지 체크하기
    let authNumberTextField = Utilities().inputContainerTextField(withPlaceholder: "인증코드 입력", fontSize: textFieldFontSize)
    
    let timer: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let authNumberCheckButton = CustomButton(title: "확인", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    
    private lazy var authBoxStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authNumberTextField, authNumberCheckButton])
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()
    
    let authNumberErrorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    lazy var authStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authBoxStack, authNumberErrorLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailStack, authStack])
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    let bottomButtonView = BottomButtonView(title: "확인")
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        authStack.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(titleLabel)
        authNumberTextField.addSubview(timer)
        addSubview(stack)
        addSubview(bottomButtonView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.763)
        }
        
        timer.snp.makeConstraints { make in
            make.centerY.equalTo(authNumberTextField)
            make.right.equalTo(authNumberTextField.snp.right).inset(11)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalTo(titleLabel)
        }
        
        requestAuthButton.snp.makeConstraints { make in
            make.width.equalTo(stack).multipliedBy(0.29)
        }
        
        authNumberCheckButton.snp.makeConstraints { make in
            make.width.equalTo(requestAuthButton)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
