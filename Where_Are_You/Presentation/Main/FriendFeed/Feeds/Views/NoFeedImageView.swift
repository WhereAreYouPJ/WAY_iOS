//
//  NoFeedImageView.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/12/2024.
//

import UIKit
import Kingfisher

class NoFeedImageView: UIView {
    // MARK: - Properties
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 8
        return blurView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 60) // 반지름 (원형)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
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
        addSubview(backgroundImage)
        backgroundImage.addSubview(blurEffectView)
        addSubview(profileImageView)
    }
    
    func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 120)) // 중앙 이미지 크기
        }
    }
    
    func configureUI(profileImage: String) {
        guard let profileImageURL = URL(string: profileImage) else { return }
        backgroundImage.kf.setImage(with: profileImageURL)
        profileImageView.kf.setImage(with: profileImageURL)
    }
}
