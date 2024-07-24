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
    }
}
