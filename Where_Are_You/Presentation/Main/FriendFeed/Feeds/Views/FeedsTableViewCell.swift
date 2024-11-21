//
//  FeedsTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "FeedsTableViewCell"
    
    let detailBox = FeedDetailBoxView()
    let feedImageView = FeedImagesView()
    let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = CustomLabel(UILabel_NotoSans: .medium, text: "asdasdasd", textColor: .color34, fontSize: LayoutAdapter.shared.scale(value: 14))
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingHead
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func configureViewComponents() {
        contentView.addSubview(detailBox)
        contentView.addSubview(feedImageView)
        contentView.addSubview(bookMarkButton)
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.backgroundColor = .color249
    }
    
    private func setupConstraints() {
        detailBox.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8))
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 74))
        }
        
        feedImageView.snp.makeConstraints { make in
            make.top.equalTo(detailBox.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 290))
        }
        
        bookMarkButton.snp.makeConstraints { make in
            make.top.equalTo(feedImageView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 6))
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 30))
            make.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(bookMarkButton.snp.bottom).offset(LayoutAdapter.shared.scale(value: 6))
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(with feed: MainFeedListContent) {
        if feed.content == nil {
            self.descriptionLabel.isHidden = true
        } else {
            descriptionLabel.isHidden = false
            descriptionLabel.text = feed.content
        }
        
        detailBox.profileImage.loadImage(from: feed.profileImage, placeholder: UIImage(named: "basic_profile_image"))
        detailBox.dateLabel.text = feed.startTime
        detailBox.locationLabel.text = feed.location
        detailBox.titleLabel.text = feed.title
    }
}
