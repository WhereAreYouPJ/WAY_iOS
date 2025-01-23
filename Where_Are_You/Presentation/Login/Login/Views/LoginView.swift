//
//  LoginAuth.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginView: UIView {
    // MARK: - Properties
    private let titleLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-short")
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = UIFont.CustomFont.bodyP4(text: "위치기반 일정관리 플랫폼")
        label.textColor = .black22
        return label
    }()
    
    let kakaoLogin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaoLogin"), for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let appleLogin: ASAuthorizationAppleIDButton = {
        let button  = ASAuthorizationAppleIDButton(type: .default, style: .black)
        button.cornerRadius = 8
        return button
    }()
    
    let accountLogin = TitleButton(title: UIFont.CustomFont.button3(text: "이메일 로그인"), backgroundColor: .white, titleColor: .brandDark, borderColor: UIColor.brandMain.cgColor, cornerRadius: 8)

    private lazy var loginStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [kakaoLogin, appleLogin, accountLogin])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let separatorLabel = CustomLabel(UILabel_NotoSans: .medium, text: "또는", textColor: .black66, fontSize: 14)
    
    let signupButton = CustomButtonView(text: "회원가입", weight: .medium, textColor: .black66, fontSize: 14)
    let findAccountButton = CustomButtonView(text: "계정찾기", weight: .medium, textColor: .black66, fontSize: 14)
    let inquiryButton = CustomButtonView(text: "문의하기", weight: .medium, textColor: .black66, fontSize: 14)
   
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signupButton, findAccountButton, inquiryButton])
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(loginStack)
        addSubview(separatorLabel)
        addSubview(buttonStack)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutAdapter.shared.scale(value: 150))
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        loginStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(46)
        }
        
        kakaoLogin.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        appleLogin.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        accountLogin.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        separatorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginStack.snp.bottom).offset(20)
        }
        
        setupLine(relatedView: separatorLabel, anchor: .leading, height: 1, width: LayoutAdapter.shared.scale(value: 100))
        setupLine(relatedView: separatorLabel, anchor: .trailing, height: 1, width: LayoutAdapter.shared.scale(value: 100))
        
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separatorLabel.snp.bottom).offset(16)
        }
        
        setupLine(relatedView: findAccountButton, anchor: .leading, height: 14, width: 1)
        setupLine(relatedView: findAccountButton, anchor: .trailing, height: 14, width: 1)
    }
    
    // 분리선 오토레이아웃
    private func setupLine(relatedView: UIView, anchor: NSLayoutConstraint.Attribute, height: CGFloat, width: CGFloat) {
        let view = UIView()
        view.backgroundColor = .color235
        
        addSubview(view)
        view.snp.makeConstraints { make in
            make.centerY.equalTo(relatedView)
            if anchor == .trailing {
                make.leading.equalTo(relatedView.snp.trailing).offset(4)
            } else {
                make.trailing.equalTo(relatedView.snp.leading).offset(-4)
            }
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
}
