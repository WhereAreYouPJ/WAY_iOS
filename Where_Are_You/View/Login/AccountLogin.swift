//
//  AccountLogin.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

class AccountLogin: UIView {
    // MARK: - Properties
    
    private let titleLabel: UIView = {
        let label = Utilities().createLabel(NotoSans: .bold, text: "로그인하기", textColor: .color34, fontSize: 22)
        let view = Utilities().inputContainerView(label: label)
        return view
    }()
    
    private let idLabel: UIView = {
        let label = Utilities().createLabel(NotoSans: .medium, text: "아이디", textColor: .color51, fontSize: 12)
        let view = Utilities().inputContainerView(label: label)
        return view
    }()
    
    private let idTextField: UIView = {
        let tf = Utilities().textField(withPlaceholder: "아이디를 입력해주세요.")
        let view = Utilities().inputContainerView(textField: tf)
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return view
    }()
    
    private let idErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        return label
    }()
    
    private let passwordLabel: UIView = {
        let label = Utilities().createLabel(NotoSans: .medium, text: "비밀번호", textColor: .color51, fontSize: 12)
        let view = Utilities().inputContainerView(label: label)
        return view
    }()
    
    private let passwordTextField: UIView = {
        let tf = Utilities().textField(withPlaceholder: "비밀번호를 입력해주세요.")
        let view = Utilities().inputContainerView(textField: tf)
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return view
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        return label
    }()
    
    let loginButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = UIFont(name: "NotoSansMyanmar-Bold", size: 18)
        button.setTitle("로그인하기", for: .normal)
        button.backgroundColor = .brancColor
        button.titleLabel?.textColor = UIColor.rgb(red: 242, green: 242, blue: 242)
        button.layer.cornerRadius = 7
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
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
        
        addSubview(loginStack)
        loginStack.centerX(inView: self, topAnchor: titleLabel.bottomAnchor, paddingTop: 30)
        loginStack.anchor(left: leftAnchor, paddingLeft: 21)

        addSubview(loginButton)
        loginButton.centerX(inView: self, topAnchor: loginStack.bottomAnchor, paddingTop: 30)
        loginButton.anchor(left: loginStack.leftAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
