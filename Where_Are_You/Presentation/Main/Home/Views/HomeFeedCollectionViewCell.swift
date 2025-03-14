//
//  HomeFeedCollectionViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

protocol HomeFeedCollectionViewCellDelegate: AnyObject {
    func didTapReadMoreButton(for feed: Feed)
}

class HomeFeedCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let identifier = "HomeFeedCollectionViewCell"
    weak var delegate: HomeFeedCollectionViewCellDelegate?
    
    var feed: Feed?
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        return iv
    }()
    
    private let userNameLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "u", textColor: .black22))
    
    private let locationLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "l", textColor: .black66))
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "t", textColor: .black22))
    
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
    
    private let descriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "u", textColor: .black22))
    
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
        setupActions()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 상태 초기화
        feedImageView.image = nil
        feedImageView.subviews.forEach { $0.removeFromSuperview() }
        descriptionLabel.text = nil
        descriptionLabel.isHidden = true
        descriptionLabel.lineBreakMode = .byCharWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        contentView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 16)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.blackF0.cgColor
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
        
        profileImageView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 56))
        }

        feedContentStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(LayoutAdapter.shared.scale(value: 40))
        }
        
        feedImageView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 80)).priority(UILayoutPriority(999))
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with feed: Feed) {
        self.feed = feed
        
        profileImageView.kf.setImage(with: URL(string: feed.profileImageURL), placeholder: UIImage(named: "basic_profile_image"))
        locationLabel.text = feed.location
        titleLabel.text = feed.title
        descriptionLabel.isHidden = true
        let feedImageInfos = feed.feedImageInfos ?? []
        if let content = feed.content { // 피드 content가 있는 경우
            descriptionLabel.isHidden = false
            descriptionLabel.text = content
            let readmoreFont = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
            let readmoreFontColor = UIColor.brandLight
            DispatchQueue.main.async {
                self.descriptionLabel.addTrailing(with: "...", moreText: "  더 보기", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
            }
            
            if let feedImage = feedImageInfos.first?.feedImageURL {
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
            if let feedImage = feedImageInfos.first?.feedImageURL { // 피드 content가 없는 경우 ,피드 이미지가 있는 경우
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
    
    func setupActions() {
        let descriptionLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionLabelTapped))
        descriptionLabel.isUserInteractionEnabled = true // UILabel에서 제스처를 받을 수 있도록 설정
        descriptionLabel.addGestureRecognizer(descriptionLabelTapGesture)
    }
    
    @objc private func descriptionLabelTapped() {
        guard let feed = feed else { return }
        delegate?.didTapReadMoreButton(for: feed)
    }
}
