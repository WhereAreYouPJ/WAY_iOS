//
//  CheckIDView.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/6/2024.
//

import UIKit
import SnapKit

class AccountCheckView: UIView {
    // MARK: - Properties
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "회원님의 가입정보를 확인해주세요", textColor: .color34, fontSize: 22)
    
    private let emailLabel = CustomLabel(UILabel_NotoSans: .medium, text: "회원님의 가입정보와 일치하는 이메일 주소는", textColor: .color34, fontSize: 14)
    
    let accountImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-account")
        return imageView
    }()
    
    var emailDescriptionLabel = CustomLabel(UILabel_NotoSans: .bold, text: "", textColor: .letterBrandColor, fontSize: 18)
    
    private let emailLabel2 = CustomLabel(UILabel_NotoSans: .medium, text: "입니다.", textColor: .color34, fontSize: 14)
    
    private lazy var emailDescriptionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [accountImage, emailDescriptionLabel, emailLabel2])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .color231
        return view
    }()
    
    private let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: "로그인 또는 비밀번호 찾기 버튼을 눌러주세요.", textColor: .color102, fontSize: 14)
    
    let loginButton = CustomButton(title: "로그인하기", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
    let searchPasswordButton: UIButton = {
        let button = CustomButton(title: "비밀번호 재설정", backgroundColor: .white, titleColor: .letterBrandColor, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
        button.layer.borderColor = UIColor.brandColor.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, searchPasswordButton])
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureViewComponents() {
        addSubview(titleLabel)
        addSubview(emailLabel)
        addSubview(emailDescriptionStack)
        addSubview(separatorView)
        addSubview(descriptionLabel)
        addSubview(buttonStack)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.48)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(41)
            make.leading.equalToSuperview().inset(15)
        }
        
        emailDescriptionStack.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom)
            make.leading.equalTo(emailLabel.snp.leading)
        }
        
        accountImage.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(emailDescriptionStack.snp.bottom).offset(6)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(15)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(buttonStack.snp.width).multipliedBy(0.14)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
        }
    }
}
