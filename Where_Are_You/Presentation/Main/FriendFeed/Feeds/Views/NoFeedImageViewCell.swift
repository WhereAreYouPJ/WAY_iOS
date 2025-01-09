//
//  NoFeedImageViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/1/2025.
//

import UIKit

class NoFeedImageViewCell: UICollectionViewCell {
    static let identifier = "NoFeedImageViewCell"
    
    private let noFeedImageView = NoFeedImageView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        noFeedImageView.backgroundImage.image = nil
        noFeedImageView.profileImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func configureViewComponents() {
        noFeedImageView.backgroundImage.layer.cornerRadius = LayoutAdapter.shared.scale(value: 6)
        contentView.addSubview(noFeedImageView)
    }
    
    func setupConstraints() {
        noFeedImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(profileImage: String) {
        noFeedImageView.configureUI(profileImage: profileImage)
    }
}
