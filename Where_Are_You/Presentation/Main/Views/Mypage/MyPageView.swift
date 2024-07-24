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
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "유저 이름", textColor: .white, fontSize: 20)
    
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
        backgroundColor = .white
        
        addSubview(profileBackgroundView)
        profileBackgroundView.addSubview(profileImageView)
        profileBackgroundView.addSubview(userNameLabel)
    }
    
    func setupConstraints() {
        profileBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            
        }
    }
}
