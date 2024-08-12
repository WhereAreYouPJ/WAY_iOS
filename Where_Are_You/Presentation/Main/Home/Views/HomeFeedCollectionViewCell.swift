//
//  HomeFeedCollectionViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class HomeFeedCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    static let identifier = "HomeFeedCollectionViewCell"
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 14
        return iv
    }()
    
    private let locationLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color102, fontSize: 14)
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color34, fontSize: 16)
    
    // 장소, 타이틀
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationLabel, titleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    // 프로필 이미지, (장소, 타이틀)
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, textStackView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.textColor = .color118
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 4
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
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

    private func configureViewComponents() {
        contentView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 16)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.color212.cgColor
        contentView.addSubview(mainStack)
    }
    
    private func setupConstraints() {
        mainStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.leading.equalToSuperview().inset(12)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(textStackView.snp.height)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with feed: Feed) {
        profileImageView.image = feed.profileImage
        locationLabel.text = feed.location
        titleLabel.text = feed.title
        descriptionLabel.text = feed.description
    }
}
