//
//  CheckIDView.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/6/2024.
//

import UIKit
import SnapKit

class CheckIDView: UIView {
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "회원님의 아이디를 확인해주세요", textColor: .color34, fontSize: 22)
    
    private let idLabel = CustomLabel(UILabel_NotoSans: .medium, text: "회원님의 아이디는", textColor: .color34, fontSize: 14)
    
    lazy var idDescriptionLabel = CustomLabel(UILabel_NotoSans: .bold, text: "", textColor: .letterBrandColor, fontSize: 18)
    
    private let idLabel2 = CustomLabel(UILabel_NotoSans: .medium, text: "입니다.", textColor: .color34, fontSize: 14)
    
    let separatorView = UIView()
    
    private let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: "로그인 또는 비밀번호 찾기 버튼을 눌러주세요.", textColor: .color102, fontSize: 14)
    
    lazy var loginButton = CustomButton(title: "로그인하기", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
    lazy var searchPasswordButton = CustomButton(title: "비밀번호 찾기", backgroundColor: .white, titleColor: .letterBrandColor, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupTitle()
        setupDescription()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func setupTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.48)
        }
    }
    
    func setupDescription() {
        let idDescriptionStack = UIStackView(arrangedSubviews: [idDescriptionLabel, idLabel2])
        idDescriptionStack.axis = .horizontal
        
        let stack = UIStackView(arrangedSubviews: [idLabel, idDescriptionStack])
        stack.axis = .vertical
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(41)
            make.left.equalToSuperview().offset(15)
        }
        
        addSubview(separatorView)
        separatorView.backgroundColor = .color234
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.left.right.equalTo(stack)
            make.top.equalTo(stack.snp.bottom).offset(6)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(12)
            make.left.equalTo(stack)
        }
    }
    
    func setupButtons() {
        let buttonStack = UIStackView(arrangedSubviews: [loginButton, searchPasswordButton])
        buttonStack.spacing = 10
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        
        searchPasswordButton.layer.borderColor = UIColor.brandColor.cgColor
        searchPasswordButton.layer.borderWidth = 1
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(buttonStack.snp.width).multipliedBy(0.14)
        }
        
        addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
        }
    }
}
