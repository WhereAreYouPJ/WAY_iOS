//
//  MypageView.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/7/2024.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    // MARK: - Properties
    
    private let profileBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandColor
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 34.44
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "exampleProfileImage")
        return imageView
    }()
    
    let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "유저 이름", textColor: .white, fontSize: 20)
    
    let codeBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    
    let userCodeLabel = CustomLabel(UILabel_NotoSans: .medium, text: "qwer0865", textColor: .letterBrandColor, fontSize: 14)
    
    // 버튼 묶음 1
    let mainStackView = UIStackView()
    
    // 버튼 묶음 2
    let additionalStackView = UIStackView()
    
    let logoutButton = CustomButtonView(text: "로그아웃", weight: .medium, textColor: .color190, fontSize: 14)
    
    let separatorview: UIView = {
        let view = UIView()
        view.backgroundColor = .color190
        return view
    }()
    
    let deleteAccountButton = CustomButtonView(text: "회원탈퇴", weight: .medium, textColor: .color190, fontSize: 14)
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoutButton, deleteAccountButton])
        stack.spacing = 4
        stack.axis = .horizontal
        return stack
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
    
    func configureViewComponents() {
        backgroundColor = .color240
        
        addSubview(profileBackgroundView)
        profileBackgroundView.addSubview(profileImageView)
        profileBackgroundView.addSubview(userNameLabel)
        
        addSubview(codeBackgroundView)
        codeBackgroundView.addSubview(userCodeLabel)
        
        addSubview(buttonStack)
        addSubview(separatorview)
    }
    
    func setupConstraints() {
        profileBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(0.747)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileBackgroundView.snp.top).inset(90)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(self.snp.width).multipliedBy(0.266)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        codeBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(profileBackgroundView.snp.bottom)
            make.height.equalTo(profileBackgroundView.snp.height).multipliedBy(0.203)
            make.leading.trailing.equalToSuperview().inset(6)
        }
        
        userCodeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        buttonStack.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(120)
            make.height.equalTo(buttonStack.snp.width).multipliedBy(0.206)
        }
        
        separatorview.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(7)
            make.top.bottom.equalToSuperview().inset(7)
        }
    }
}
