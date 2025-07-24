//
//  FeedDetailBoxView.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/8/2024.
//

import UIKit
import Kingfisher

// scheduleInfo 관련 내용들
class FeedDetailBoxView: UIView {
    // MARK: - Properties
    let detailBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blackD4.cgColor
        return view
    }()
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var userNameLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "u", textColor: .black22))
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.blackD4.cgColor
        view.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 12))
            make.width.equalTo(1)
        }
        view.clipsToBounds = true
        return view
    }()
    
    var locationLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "l", textColor: .black66))
    
    var titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "t", textColor: .black22))
    
    private let radialGradient = CAGradientLayer()
    private let borderGradient = CAGradientLayer()
    private let borderMask = CAShapeLayer()
    
    let participantBoxView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.blackF8.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 19)
        view.clipsToBounds = true
        view.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 38))
        }
        return view
    }()
    
    let plusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-plus")
        imageView.tintColor = .gray
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 16))
        }
        return imageView
    }()
    
    private let participantStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let feedFixButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-3dots"), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradients()
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 🔹 radial frame 업데이트
        radialGradient.frame = participantBoxView.bounds
        
        // 🔹 borderGradient + mask path 업데이트
        borderGradient.frame = participantBoxView.bounds
        let cornerRadius = LayoutAdapter.shared.scale(value: 19)
        let path = UIBezierPath(
            roundedRect: participantBoxView.bounds,
            cornerRadius: cornerRadius
        ).cgPath
        borderMask.path = path
        
        print("Gradient Frame:", radialGradient.frame)
        print("ParticipantBox Frame:", participantBoxView.frame)
    }
    
    // MARK: - Helpers
    private func setupGradients() {
        // 🔹 Radial gradient 설정
        radialGradient.type = .radial
        radialGradient.colors = [
            UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00).cgColor,
            UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00).cgColor
        ]
        radialGradient.locations = [0, 1]
        radialGradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        radialGradient.endPoint = CGPoint(x: 1, y: 1)
        participantBoxView.layer.insertSublayer(radialGradient, at: 0)
        
        // 🔹 Linear gradient 설정
        borderGradient.colors = [
            UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00).cgColor,
            UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.00).cgColor
        ]
        borderGradient.startPoint = CGPoint(x: 0, y: 0)
        borderGradient.endPoint = CGPoint(x: 1, y: 1)
        borderGradient.mask = borderMask
        participantBoxView.layer.addSublayer(borderGradient)
    }
    
    private func configureViewComponents() {
        addSubview(detailBox)
        detailBox.addSubview(profileImage)
        detailBox.addSubview(userNameLabel)
        detailBox.addSubview(separatorView)
        detailBox.addSubview(locationLabel)
        detailBox.addSubview(titleLabel)
        detailBox.addSubview(feedFixButton)
        
        addSubview(participantBoxView)
        participantBoxView.addSubview(participantStackView)
        participantBoxView.addSubview(plusImage)
        
        userNameLabel.setContentHuggingPriority(.required, for: .horizontal)
        userNameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        locationLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        locationLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setupConstraints() {
        detailBox.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 56))
            make.top.bottom.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 4))
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(LayoutAdapter.shared.scale(value: 10))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 9))
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(userNameLabel.snp.trailing).offset(LayoutAdapter.shared.scale(value: 6))
            make.centerY.equalTo(userNameLabel)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(separatorView.snp.trailing).offset(LayoutAdapter.shared.scale(value: 6))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 9))
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 4))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 4))
            make.leading.equalTo(profileImage.snp.trailing).offset(LayoutAdapter.shared.scale(value: 10))
            make.trailing.equalTo(feedFixButton.snp.leading)
        }
        
        feedFixButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 6))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 9))
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 24))
        }
        
        participantBoxView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: -19))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 38))
        }
        
        plusImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 6))
        }
        
        participantStackView.snp.makeConstraints { make in
            make.leading.equalTo(plusImage.snp.trailing).offset(LayoutAdapter.shared.scale(value: 4))
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 6))
            make.centerY.equalToSuperview()
        }
    }
    
    private func createStackView(subviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = axis
        stackView.spacing = spacing
        return stackView
    }
    
    func resetUI() {
        userNameLabel.attributedText = nil
        locationLabel.attributedText = nil
        titleLabel.attributedText = nil
        profileImage.image = nil
    }
    
    func configure(with feed: Feed) {
        let scheduleFriendInfos = feed.scheduleFriendInfos ?? []
        let memberSeq = feed.memberSeq
        let participants = scheduleFriendInfos.compactMap { $0 }.filter { $0.memberSeq != memberSeq }.map { $0.profileImageURL }
        
        configureParticipantImages(participants: participants)
        profileImage.kf.setImage(with: URL(string: feed.profileImageURL), placeholder: UIImage(named: "basic_profile_image"))
        userNameLabel.updateTextKeepingAttributes(newText: feed.userName)
        locationLabel.updateTextKeepingAttributes(newText: feed.location)
        titleLabel.updateTextKeepingAttributes(newText: feed.title)
    }
    
    func configureParticipantImages(participants: [String]) {
        if participants.isEmpty {
            participantBoxView.isHidden = true
        } else {
            participantBoxView.isHidden = false
            participantStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            for (index, image) in participants.prefix(3).enumerated() {
                let imageView = UIImageView()
                imageView.kf.setImage(with: URL(string: image))
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 13)
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(LayoutAdapter.shared.scale(value: 26))
                }
                participantStackView.addArrangedSubview(imageView)
                imageView.layer.zPosition = CGFloat(3 - index)
            }
        }
    }
}
