//
//  AccountLogin.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

class AccountLogin: UIView {
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = Utilities().fontLabel(fontStyle: .bold, text: "로그인하기", size: 22)
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = Utilities().fontLabel(fontStyle: .medium, text: "  아이디", size: 12)
        label.heightAnchor.constraint(equalToConstant: 23).isActive = true
        return label
    }()
    
    private let idTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "   아이디를 입력해주세요.")
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.boxBorderColor.cgColor
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return tf
    }()
    
    private let idErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFont.pretendard(size: 12, weight: .medium)
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = Utilities().fontLabel(fontStyle: .medium, text: "  비밀번호", size: 12)
        label.heightAnchor.constraint(equalToConstant: 23).isActive = true
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "   비밀번호를 입력해주세요.")
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.boxBorderColor.cgColor
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return tf
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFont.pretendard(size: 12, weight: .medium)
        return label
    }()
    
    let loginButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = UIFont(name: "NotoSansMyanmar-Bold", size: 18)
        button.setTitle("로그인하기", for: .normal)
        button.backgroundColor = .brancColor
        button.heightAnchor.constraint(equalToConstant: 50)
        button.titleLabel?.textColor = UIColor.rgb(red: 242, green: 242, blue: 242)
        return button
    }()
    
//    let loginButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "loginButton"), for: .normal)
//        return button
//    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 124, paddingLeft: 21)
        
        let idStack = UIStackView(arrangedSubviews: [idLabel, idTextField, idErrorLabel])
        idStack.axis = .vertical
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField, passwordErrorLabel])
        passwordStack.axis = .vertical
        
        let loginStack = UIStackView(arrangedSubviews: [idStack, passwordStack])
        loginStack.spacing = 10
        loginStack.axis = .vertical
        
        let stack = UIStackView(arrangedSubviews: [loginStack, loginButton])
        stack.spacing = 30
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerX(inView: self, topAnchor: titleLabel.bottomAnchor, paddingTop: 30)
        stack.anchor(left: leftAnchor, paddingLeft: 21)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
