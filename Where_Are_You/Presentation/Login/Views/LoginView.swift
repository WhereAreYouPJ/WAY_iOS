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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(Ttangsbudae: .bold, fontSize: 36))
        label.adjustsFontForContentSizeCategory = true
        label.text = "지금 어디?"
        label.textColor = .letterBrandColor
        return label
    }()
    
    private let subtitleLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: "위치기반 일정관리 플랫폼", textColor: .color68, fontSize: 14)
    
    let kakaoLogin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakaoLogin"), for: .normal)
        return button
    }()
    
    let appleLogin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "appleLogin"), for: .normal)
        return button
    }()
    
    let accountLogin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "accountLogin"), for: .normal)
        return button
    }()
    
    let separatorLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: "또는", textColor: .color102, fontSize: 14)
    
    let signupButton = CustomButtonView(text: "회원가입", weight: .medium, textColor: .color102, fontSize: 14)
    let findAccountButton = CustomButtonView(text: "계정찾기", weight: .medium, textColor: .color102, fontSize: 14)
    let inquiryButton = CustomButtonView(text: "문의하기", weight: .medium, textColor: .color102, fontSize: 14)
   
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(150)
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        let loginStack = UIStackView(arrangedSubviews: [kakaoLogin, appleLogin, accountLogin])
        loginStack.axis = .vertical
        loginStack.spacing = 10
        loginStack.distribution = .fillEqually
        
        addSubview(loginStack)
        loginStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitleLabel.snp.bottom).offset(46)
        }
        
        addSubview(separatorLabel)
        separatorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginStack.snp.bottom).offset(20)
        }
        
        setupLine(relatedView: separatorLabel, anchor: .left, height: 1, width: 100)
        setupLine(relatedView: separatorLabel, anchor: .right, height: 1, width: 100)
        
        let buttonStack = UIStackView(arrangedSubviews: [signupButton, findAccountButton, inquiryButton])
        buttonStack.spacing = 8
        buttonStack.axis = .horizontal
        
        addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separatorLabel.snp.bottom).offset(16)
        }
        
        setupLine(relatedView: findAccountButton, anchor: .left, height: 14, width: 1)
        setupLine(relatedView: findAccountButton, anchor: .right, height: 14, width: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    // 분리선 오토레이아웃
    private func setupLine(relatedView: UIView, anchor: NSLayoutConstraint.Attribute, height: CGFloat, width: CGFloat) {
        let view = UIView()
        view.backgroundColor = .color234
        
        addSubview(view)
        view.snp.makeConstraints { make in
            make.centerY.equalTo(relatedView)
            if anchor == .right {
                make.left.equalTo(relatedView.snp.right).offset(4)
            } else {
                make.right.equalTo(relatedView.snp.left).offset(-4)
            }
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
}
