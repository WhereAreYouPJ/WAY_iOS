//
//  FeedDetailBoxView.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/8/2024.
//

import UIKit

// scheduleInfo 관련 내용들
class FeedDetailBoxView: UIView {
    // MARK: - Properties

    let detailBox: UIView = {
        let view = UIView()
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.brandColor.cgColor
        return view
    }()
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var dateLabel = CustomLabel(UILabel_NotoSans: .medium, text: "dateLabel", textColor: .color153, fontSize: LayoutAdapter.shared.scale(value: 14))
    
    var locationLabel = CustomLabel(UILabel_NotoSans: .medium, text: "locationLabel", textColor: .color153, fontSize: LayoutAdapter.shared.scale(value: 14))
    
    var titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "titleLabel", textColor: .color34, fontSize: LayoutAdapter.shared.scale(value: 16))
    
    // 스케쥴 날짜, 스케쥴 장소
    lazy var dateLocationStack = createStackView(subviews: [dateLabel, locationLabel], axis: .horizontal, spacing: 0)
    
    // (스케쥴 날짜, 스케쥴 장소), 피드 제목
    lazy var titleStack = createStackView(subviews: [dateLocationStack, titleLabel], axis: .vertical, spacing: 0)
    
    // ((스케쥴 날짜, 스케쥴 장소), 피드 제목), 프로필 이미지
    lazy var profileStack = createStackView(subviews: [profileImage, titleStack], axis: .horizontal, spacing: 0)
    
    let participantBoxView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.rgb(red: 200, green: 171, blue: 229).cgColor
        view.backgroundColor = UIColor.rgb(red: 238, green: 238, blue: 238).withAlphaComponent(8)
        view.layer.borderWidth = 1
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 50)
        view.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 30))
        }
        return view
    }()
    
    let plusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-plus")
        imageView.tintColor = .gray
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 15.87))
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
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        addSubview(detailBox)
        detailBox.addSubview(profileStack)
        addSubview(participantBoxView)
        participantBoxView.addSubview(participantStackView)
        participantBoxView.addSubview(plusImage)
        detailBox.addSubview(feedFixButton)
    }
    
    private func setupConstraints() {
        detailBox.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.centerY.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
        
        feedFixButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 30))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 24))
        }
        
        participantBoxView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 8))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 30))
        }
        
        plusImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 4))
        }
        
        participantStackView.snp.makeConstraints { make in
            make.leading.equalTo(plusImage.snp.trailing)
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.centerY.equalToSuperview()
        }
    }
    
    private func createStackView(subviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = axis
        stackView.spacing = spacing
        return stackView
    }
    
    func configureParticipantImages(participants: [UIImage]) {
        participantStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, image) in participants.prefix(3).enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 9)
            imageView.layer.borderWidth = 1.6
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(LayoutAdapter.shared.scale(value: 26))
            }
            participantStackView.addArrangedSubview(imageView)
            imageView.layer.zPosition = CGFloat(3 - index)
        }
        
        participantStackView.isHidden = participants.isEmpty
    }
}
