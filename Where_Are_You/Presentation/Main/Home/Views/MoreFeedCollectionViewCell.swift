//
//  MoreFeedCollectionViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/8/2024.
//

import UIKit

protocol MoreFeedCollectionViewCellDelegate: AnyObject {
    func didTapMoreButton()
}

class MoreFeedCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MoreFeedCollectionViewCellDelegate?

    static let identifier = "MoreFeedCollectionViewCell"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.image = UIImage(named: "exampleProfileImage")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 하루 지나온 경험을 \n기록하고 공유해보세요."
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.numberOfLines = 2
        label.textColor = .color153
        return label
    }()
    
    let moreFeedButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "더 보기"
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        button.titleLabel?.textColor = .letterBrandColor
        return button
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
        moreFeedButton.addTarget(self, action: #selector(moreFeedButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func moreFeedButtonTapped() {
        delegate?.didTapMoreButton()
    }
    
    private func configureViewComponents() {
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.color212.cgColor
        contentView.addSubview(profileImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(moreFeedButton)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        moreFeedButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
