//
//  ProfileView.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit
import SnapKit

class ProfileView: UIView {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "exampleProfileImage")
        return imageView
    }()
    
    let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "유민혁", textColor: .color34, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewComponents() {
        addSubview(profileImageView)
        addSubview(userNameLabel)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.15)
            make.height.equalTo(profileImageView.snp.width)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
        }
    }
}
