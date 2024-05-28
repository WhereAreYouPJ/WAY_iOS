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
        label.font = UIFont.pretendard(Ttangsbudae: .bold, fontSize: 36)
        label.text = "지금 어디?"
        label.textColor = .letterBrandColor
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.text = "위치기반 일정관리 플랫폼"
        label.textColor = .color68
        return label
    }()
    
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
    
    let leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = .color234
        return view
    }()
    
    let rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = .color234
        return view
    }()
    
    let separatorLabel: UILabel = {
        let label = Utilities().createLabel(NotoSans: .medium, text: "또는", textColor: .color102, fontSize: 14)
        return label
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.color102, for: .normal)
        button.setDimensions(width: 64, height: 28)
        return button
    }()
    
    let findAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("계정찾기", for: .normal)
        button.setTitleColor(.color102, for: .normal)
        return button
    }()
    
    let inquiryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("문의하기", for: .normal)
        button.setTitleColor(.color102, for: .normal)
        return button
    }()
    
    let firstLine: UIView = {
        let view = UIView()
        view.backgroundColor = .color234
        return view
    }()
    
    let secondLine: UIView = {
        let view = UIView()
        view.backgroundColor = .color234
        return view
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self, topAnchor: safeAreaLayoutGuide.topAnchor, paddingTop: 150)
        
        addSubview(subtitleLabel)
        subtitleLabel.centerX(inView: titleLabel, topAnchor: titleLabel.bottomAnchor)
        
        let loginStack = UIStackView(arrangedSubviews: [kakaoLogin, appleLogin, accountLogin])
        loginStack.axis = .vertical
        loginStack.spacing = 10
        loginStack.distribution = .fillEqually
        
        addSubview(loginStack)
        loginStack.centerX(inView: self, topAnchor: subtitleLabel.bottomAnchor, paddingTop: 46)
        
        addSubview(separatorLabel)
        separatorLabel.centerX(inView: loginStack, topAnchor: loginStack.bottomAnchor, paddingTop: 20)
        
        addSubview(leftLine)
        leftLine.setDimensions(width: 100, height: 1)
        leftLine.centerY(inView: separatorLabel)
        leftLine.anchor(right: separatorLabel.leftAnchor, paddingRight: 12)
        
        addSubview(rightLine)
        rightLine.setDimensions(width: 100, height: 1)
        rightLine.centerY(inView: separatorLabel, leftAnchor: separatorLabel.rightAnchor, paddingLeft: 12)
        
        let buttonStack = UIStackView(arrangedSubviews: [signupButton, findAccountButton, inquiryButton])
        buttonStack.spacing = 8
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: separatorLabel, topAnchor: separatorLabel.bottomAnchor, paddingTop: 16)
        
        addSubview(firstLine)
        firstLine.centerY(inView: buttonStack)
        firstLine.anchor(left: signupButton.rightAnchor, paddingLeft: 4)
        firstLine.setDimensions(width: 1, height: 14)
        
        addSubview(secondLine)
        secondLine.centerY(inView: buttonStack)
        secondLine.anchor(left: findAccountButton.rightAnchor, paddingLeft: 4)
        secondLine.setDimensions(width: 1, height: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
