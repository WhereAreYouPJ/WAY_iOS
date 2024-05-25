//
//  LoginAuth.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

protocol LoginViewDelegate: AnyObject {
    func accountLoginTapped()
}

class LoginView: UIView {
    // MARK: - Properties
    
    weak var delegate: LoginViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(size: 36, weight: .bold)
        label.text = "지금 어디?"
        label.textColor = UIColor.letterBrandColor
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = Utilities().fontLabel(fontStyle: .medium, text: "위치기반 일정관리 플랫폼", size: 14)
        label.textColor = UIColor.rgb(red: 68, green: 68, blue: 68)
        return label
    }()
    
    private lazy var kakaoLogin: UIImageView = {
        let iv = UIImageView()
        let image = #imageLiteral(resourceName: "kakaoLogin")
        iv.image = image
        iv.layer.cornerRadius = 50
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(kakaoLoginTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(followTap)
        
        return iv
    }()
    
    private lazy var appleLogin: UIImageView = {
        let iv = UIImageView()
        let image = #imageLiteral(resourceName: "appleLogin")
        iv.image = image
        iv.layer.cornerRadius = 50
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(appleLoginTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(followTap)
        
        return iv
    }()
    
    private lazy var accountLogin: UIImageView = {
        let iv = UIImageView()
        let image = #imageLiteral(resourceName: "accountLogin")
        iv.image = image
        iv.layer.cornerRadius = 50
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(accountLoginTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(followTap)
        
        return iv
    }()
    
    let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let separatorLabel: UILabel = {
        let label = Utilities().fontLabel(fontStyle: .medium, text: "또는", size: 14)
        label.textColor = .gray
        return label
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setDimensions(width: 64, height: 28)
        return button
    }()
    
    let findAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("계정찾기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    let inquiryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("문의하기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
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
        
        addSubview(separatorView1)
        separatorView1.setDimensions(width: 100, height: 0.5)
        separatorView1.centerY(inView: separatorLabel)
        separatorView1.anchor(right: separatorLabel.leftAnchor, paddingRight: 12)
        
        addSubview(separatorView2)
        separatorView2.setDimensions(width: 100, height: 0.5)
        separatorView2.centerY(inView: separatorLabel, leftAnchor: separatorLabel.rightAnchor, paddingLeft: 12)
        
        let buttonStack = UIStackView(arrangedSubviews: [signupButton, findAccountButton, inquiryButton])
        buttonStack.spacing = 8
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: separatorLabel, topAnchor: separatorLabel.bottomAnchor, paddingTop: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func kakaoLoginTapped() {
        
    }
    
    @objc func appleLoginTapped() {
        
    }
    
    @objc func accountLoginTapped() {
        delegate?.accountLoginTapped()
    }

}
