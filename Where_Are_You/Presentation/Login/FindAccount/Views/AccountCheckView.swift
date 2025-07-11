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
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "회원님의 가입정보를 \n확인해주세요", textColor: .black22))
    
    private let emailLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "회원님의 가입정보와 일치하는 이메일은", textColor: .black22))
    
    let accountImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-account")
        return imageView
    }()
    
    var emailDescriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "", textColor: .brandDark))
    
    private let emailLabel2 = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "입니다.", textColor: .black22))
    
    private lazy var emailDescriptionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [accountImage, emailDescriptionLabel, emailLabel2])
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackD4
        return view
    }()
    
    private let descriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "로그인 또는 비밀번호 재설정 버튼을 눌러주세요.", textColor: .black66))
    
    let loginButton = TitleButton(title: UIFont.CustomFont.button18(text: "로그인하기", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
    let searchPasswordButton = TitleButton(title: UIFont.CustomFont.button18(text: "비밀번호 재설정", textColor: .brandDark), backgroundColor: .white, borderColor: UIColor.brandMain.cgColor)
    
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
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 54))
            make.leading.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 24))
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 40))
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        emailDescriptionStack.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.leading.equalTo(emailLabel.snp.leading)
        }
        
        accountImage.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 32))
        }
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(emailDescriptionStack.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
        
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
        }
    }
    
    func setupLogoImage(email: String) {
        emailDescriptionLabel.attributedText = UIFont.CustomFont.bodyP3(text: email, textColor: .brandDark)
    }
}
