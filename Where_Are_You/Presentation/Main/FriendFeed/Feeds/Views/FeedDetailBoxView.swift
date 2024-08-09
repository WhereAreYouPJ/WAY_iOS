//
//  FeedDetailBoxView.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/8/2024.
//

import UIKit

class FeedDetailBoxView: UIView {
    // MARK: - Properties

    let detailBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.brandColor.cgColor
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let dateLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color153, fontSize: 14)
    
    let locationLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color153, fontSize: 14)
    
    let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color34, fontSize: 16)
    
    lazy var dateLocationStack = createStackView(subviews: [dateLabel, locationLabel], axis: .horizontal, spacing: 0)
    
    lazy var titleStack = createStackView(subviews: [dateLocationStack, titleLabel], axis: .vertical, spacing: 0)
    
    lazy var profileStack = createStackView(subviews: [profileImage, titleStack], axis: .horizontal, spacing: 0)
    
    let feedFixButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-3dots"), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
        feedFixButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        addSubview(detailBox)
        detailBox.addSubview(profileStack)
        profileStack.addSubview(feedFixButton)
    }
    
    private func setupConstraints() {
        profileStack.snp.makeConstraints { make in
            make.center.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
        }
        
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
        
        feedFixButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 30))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 24))
        }
    }
    
    private func createStackView(subviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = axis
        stackView.spacing = spacing
        return stackView
    }
}
