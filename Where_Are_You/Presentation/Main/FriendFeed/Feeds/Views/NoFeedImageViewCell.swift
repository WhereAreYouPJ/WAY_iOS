//
//  NoFeedImageViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/1/2025.
//

import UIKit

class NoFeedImageViewCell: UICollectionViewCell {
    static let identifier = "NoFeedImageViewCell"

    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 6)
        return imageView
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.8
        return blurView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 60) // 반지름 (원형)
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
        profileImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureViewComponents() {
        contentView.addSubview(backgroundImage)
        backgroundImage.addSubview(blurEffectView)
        backgroundImage.addSubview(profileImageView)
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
        guard let profileImageURL = URL(string: profileImage) else {
            print("Invalid profile image URL")
            return
        }
        let placeholderImage = UIImage(named: "basic_profile_image")
        backgroundImage.kf.setImage(with: profileImageURL, placeholder: placeholderImage)
        profileImageView.kf.setImage(with: profileImageURL, placeholder: placeholderImage)
    }
}
