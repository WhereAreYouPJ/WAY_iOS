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
    
    private let subtitleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "위치기반 일정관리 플랫폼", textColor: .black22))
    
    let kakaoLogin: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        
        configuration.image = UIImage(named: "kakao")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10
        
        let nsAttributedString = UIFont.CustomFont.button16(text: "카카오로 시작하기", textColor: .black22)
        configuration.attributedTitle = AttributedString(nsAttributedString)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)

        button.configuration = configuration
        button.backgroundColor = .secondaryNormal
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let appleLogin: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        
        configuration.image = UIImage(systemName: "apple.logo")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        configuration.imagePlacement = .leading
        configuration.imagePadding = 10

        let nsAttributedString = UIFont.CustomFont.button16(text: "Apple로 로그인", textColor: .white)
        configuration.attributedTitle = AttributedString(nsAttributedString)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)

        button.configuration = configuration
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let accountLogin = TitleButton(title: UIFont.CustomFont.button16(text: "이메일 로그인", textColor: .brandDark), backgroundColor: .white, borderColor: UIColor.brandMain.cgColor)

    private lazy var loginStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [kakaoLogin, appleLogin, accountLogin])
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let separatorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "또는", textColor: .black66))
    
    let signupButton = StandardButton(text: UIFont.CustomFont.bodyP4(text: "회원가입", textColor: .black66))
    let findAccountButton = StandardButton(text: UIFont.CustomFont.bodyP4(text: "계정찾기", textColor: .black66))
    let inquiryButton = StandardButton(text: UIFont.CustomFont.bodyP4(text: "문의하기", textColor: .black66))
   
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signupButton, findAccountButton, inquiryButton])
        stackView.spacing = 20
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
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutAdapter.shared.scale(value: 141))
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
        }
        
        loginStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 41.8))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        kakaoLogin.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
        
        separatorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginStack.snp.bottom).offset(LayoutAdapter.shared.scale(value: 52))
        }
        
        setupLine(relatedView: separatorLabel, anchor: .leading, height: 1, width: LayoutAdapter.shared.scale(value: 100))
        setupLine(relatedView: separatorLabel, anchor: .trailing, height: 1, width: LayoutAdapter.shared.scale(value: 100))
        
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separatorLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 18))
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
                make.leading.equalTo(relatedView.snp.trailing).offset(10)
            } else {
                make.trailing.equalTo(relatedView.snp.leading).offset(-10)
            }
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
}
