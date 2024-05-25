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
        let label = UILabel()
        return label
    }()
    
    private let idView: UIView = {
        let view = UIView()
        let idTextField: UITextField = {
            let tf = Utilities().textField(withPlaceholder: "아이디를 입력해주세요.")
            return tf
        }()
        
        view.addSubview(idTextField)
        idTextField.center(inView: view)
        idTextField.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 8)
        
        view.setDimensions(width: 345, height: 44)
        
        return view
    }()
    
    private let idErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFont.pretendard(size: 12, weight: .medium)
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let passwordView: UIView = {
        let view = UIView()
        let passwordTextField: UITextField = {
            let tf = Utilities().textField(withPlaceholder: "비밀번호를 입력해주세요.")
            return tf
        }()
        
        view.addSubview(passwordTextField)
        passwordTextField.center(inView: view)
        passwordTextField.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 12, paddingLeft: 8)
        
        view.setDimensions(width: 345, height: 44)
        
        return view
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .warningColor
        label.font = UIFont.pretendard(size: 12, weight: .medium)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 124, paddingLeft: 21)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
