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
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackF0
        view.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.width.equalTo(1.5)
        }
        return view
    }()
    
    private let locationLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "l", textColor: .black66))
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "t", textColor: .black22))
    
    // 이름, 장소
    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [userNameLabel, borderView, locationLabel])
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        return sv
    }()
    
    // (이름, 장소), 타이틀
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainStackView, titleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleContentView = UIView()
    
    // 프로필 이미지, (장소, 타이틀)
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, titleContentView])
        stackView.axis = .horizontal
        stackView.spacing = 10
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
        stackView.spacing = 12
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
        backgroundColor = .white
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
        contentView.addSubview(mainStack)
        titleContentView.addSubview(textStackView)
        layer.cornerRadius = LayoutAdapter.shared.scale(value: 16)
        layer.borderWidth = 1
        layer.borderColor = UIColor.blackF0.cgColor
        clipsToBounds = true
        
        // userNameLabel은 intrinsic size로 딱 맞게만
        userNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        userNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        // locationLabel은 남은 공간을 차지하도록
        locationLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        locationLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        borderView.setContentHuggingPriority(.required, for: .horizontal)
        borderView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupConstraints() {
        mainStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 16))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 56))
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 5))
            make.leading.trailing.equalToSuperview()
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
        userNameLabel.updateTextKeepingAttributes(newText: feed.userName)
        locationLabel.updateTextKeepingAttributes(newText: feed.location)
        titleLabel.updateTextKeepingAttributes(newText: feed.title)
        descriptionLabel.isHidden = true
        let feedImageInfos = feed.feedImageInfos ?? []
        if let content = feed.content { // 피드 content가 있는 경우
            descriptionLabel.isHidden = false
            descriptionLabel.updateTextKeepingAttributes(newText: content)
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
