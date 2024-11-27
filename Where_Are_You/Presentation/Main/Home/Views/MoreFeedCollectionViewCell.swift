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
    
    let borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 16)
        view.layer.borderColor = UIColor.color212.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
        button.setTitleColor(.letterBrandColor, for: .normal)
        button.setTitle("더 보기", for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
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
        contentView.addSubview(borderView)
        borderView.addSubview(profileImageView)
        borderView.addSubview(titleLabel)
        borderView.addSubview(moreFeedButton)
    }
    
    private func setupConstraints() {
        
        borderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 28))
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 50))
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
