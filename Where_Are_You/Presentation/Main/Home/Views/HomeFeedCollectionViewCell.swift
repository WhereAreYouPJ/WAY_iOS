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
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
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
    
    private var feedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 6
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.textColor = .color118
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var feedContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, feedImageView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = LayoutAdapter.shared.scale(value: 12)
        return stackView
    }()
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleStackView, feedContentStackView])
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
            make.top.leading.equalToSuperview().inset(16)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(textStackView.snp.height)
        }
        
        titleStackView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 56))
        }
        
        feedContentStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with feed: HomeFeedContent) {
        profileImageView.kf.setImage(with: URL(string: feed.profileImageURL), placeholder: UIImage(named: "basic_profile_image"))
        locationLabel.text = feed.location
        titleLabel.text = feed.title
        descriptionLabel.isHidden = true
        if let content = feed.content { // 피드 content가 있는 경우
            descriptionLabel.isHidden = false
            descriptionLabel.text = content
            if let feedImage = feed.feedImage {
                feedImageView.kf.setImage(with: URL(string: feedImage))
            } else {
                let mainNoFeedImageView = MainNoFeedImageView(frame: CGRect(x: 0, y: 0, width: LayoutAdapter.shared.scale(value: 295), height: LayoutAdapter.shared.scale(value: 80)))
                mainNoFeedImageView.configureUI(profileImage: feed.profileImageURL)
                feedImageView.addSubview(mainNoFeedImageView)
                mainNoFeedImageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        } else { // 피드 content가 없는 경우
            descriptionLabel.isHidden = true
            if let feedImage = feed.feedImage { // 피드 content가 없는 경우 ,피드 이미지가 있는 경우
                feedImageView.kf.setImage(with: URL(string: feedImage))
            } else {
                let mainNoFeedImageView = MainNoFeedImageView(frame: CGRect(x: 0, y: 0, width: LayoutAdapter.shared.scale(value: 295), height: LayoutAdapter.shared.scale(value: 80)))
                mainNoFeedImageView.configureUI(profileImage: feed.profileImageURL)
                feedImageView.addSubview(mainNoFeedImageView)
                mainNoFeedImageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
}
