//
//  LoginAuth.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

class LoginView: UIView {
    // MARK: - Properties
    private let titleLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-short")
        return imageView
    }()
    
    private let subtitleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "위치기반 일정관리 플랫폼", textColor: .color68, fontSize: 14)
    
    let kakaoLogin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaoLogin"), for: .normal)
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 6)
        return button
    }()
    
    let appleLogin: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandColor
        button.setImage(UIImage(named: "appleLogin"), for: .normal)
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 6)
        return button
    }()
    
    let accountLogin: UIButton = {
        let button = UIButton()
        button.setTitle("이메일 로그인", for: .normal)
        button.setTitleColor(.letterBrandColor, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .bold, fontSize: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.brandColor.cgColor
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 6)
        return button
    }()
    
    private lazy var loginStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [kakaoLogin, appleLogin, accountLogin])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let separatorLabel = CustomLabel(UILabel_NotoSans: .medium, text: "또는", textColor: .color102, fontSize: 14)
    
    let signupButton = CustomButtonView(text: "회원가입", weight: .medium, textColor: .color102, fontSize: 14)
    let findAccountButton = CustomButtonView(text: "계정찾기", weight: .medium, textColor: .color102, fontSize: 14)
    let inquiryButton = CustomButtonView(text: "문의하기", weight: .medium, textColor: .color102, fontSize: 14)
   
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
