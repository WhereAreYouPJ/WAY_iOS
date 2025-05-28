//
//  SocialLinkView.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/2/2025.
//

import UIKit

class SocialLinkView: UIView {
    // MARK: - Properties
    
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .brandMain
        return view
    }()
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "잠시만요! \n이미 가입된 이메일입니다.", textColor: .black22))
    
    let displayBox: UIView = {
        let view = UIView()
        view.backgroundColor = .blackF8
        view.layer.cornerRadius = 12
        return view
    }()
    
    let accountView = UIView()
    
    let boxDescriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "계정을 연동하여 보다 간편하게 이용이 가능합니다. \n연동을 원하지 않을 경우 로그인 화면으로 돌아갑니다.", textColor: .black66))
    
    lazy var boxStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [accountView, boxDescriptionLabel])
        sv.spacing = 10
        sv.axis = .vertical
        return sv
    }()
    
    let returnButton = TitleButton(title: UIFont.CustomFont.button18(text: "이전으로 \n돌아가기", textColor: .black22), backgroundColor: .white, borderColor: UIColor.blackD4.cgColor)
    
    let linkButton = TitleButton(title: UIFont.CustomFont.button18(text: "기존 계정과 \n연동하기", textColor: .black22), backgroundColor: .white, borderColor: UIColor.blackD4.cgColor)
    
    lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [returnButton, linkButton])
        sv.spacing = 8
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
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
        addSubview(progressBar)
        addSubview(titleLabel)
        addSubview(displayBox)
        displayBox.addSubview(boxStackView)
        addSubview(buttonStackView)
    }
    
    private func setupConstraints() {
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(LayoutAdapter.shared.scale(value: 51))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        displayBox.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 40))
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        boxStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 16))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 18))
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(displayBox.snp.bottom).offset(LayoutAdapter.shared.scale(value: 24))
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 96))
        }
    }
    
    // MARK: - SNS 계정 연동 뷰 구성
    func configureAccountView(snsAccounts: [String], email: String) {
        // 기존에 추가된 서브뷰가 있다면 제거
        accountView.subviews.forEach { $0.removeFromSuperview() }
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 10
        
        for sns in snsAccounts {
//            let rowStack = UIStackView()
//            rowStack.axis = .horizontal
//            rowStack.spacing = 8
//            rowStack.alignment = .leading
//
            let contentView = UIView()
            let logoImageView = UIImageView()
            logoImageView.contentMode = .scaleAspectFit
            // SNS 종류에 따라 로고 이미지 설정 (프로젝트에 맞게 이미지 이름 수정)
            switch sns.lowercased() {
            case "kakao":
                logoImageView.image = UIImage(named: "icon-kakao")
            case "apple":
                logoImageView.image = UIImage(systemName: "apple.logo")
            default:
                logoImageView.image = UIImage(named: "icon-account")
            }
            logoImageView.snp.makeConstraints { make in
                make.height.width.equalTo(LayoutAdapter.shared.scale(value: 32))
            }
            
            let emailLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: email, textColor: .brandDark))
            
            contentView.addSubview(logoImageView)
            contentView.addSubview(emailLabel)
            logoImageView.snp.makeConstraints { make in
                make.top.leading.bottom.equalToSuperview()
            }
            emailLabel.snp.makeConstraints { make in
                make.centerY.equalTo(logoImageView)
                make.leading.equalTo(logoImageView.snp.trailing).offset(LayoutAdapter.shared.scale(value: 8))
                make.trailing.equalToSuperview()
            }
//            rowStack.addArrangedSubview(logoImageView)
//            rowStack.addArrangedSubview(emailLabel)
//            
            verticalStack.addArrangedSubview(contentView)
        }
        
        accountView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
