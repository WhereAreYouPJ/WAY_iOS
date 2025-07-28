//
//  FeedParticipantView.swift
//  Where_Are_You
//
//  Created by 오정석 on 14/1/2025.
//

import UIKit
protocol FeedParticipantDelegate: AnyObject {
    func didSelectParticipant(at index: Int)
}

class FeedParticipantView: UIView {
    weak var delegate: FeedParticipantDelegate?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let participantStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        return sv
    }()
    
    private var selectedButton: GradientButton? // 선택된 버튼을 저장할 프로퍼티
    
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
        addSubview(scrollView)
        scrollView.addSubview(participantStackView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        participantStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 37))
        }
    }
    
    func configureParticipantImages(participants: [DetailFeedInfo], delegate: FeedParticipantDelegate?) {
        self.delegate = delegate
        participantStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, participant) in participants.enumerated() {
            let button = GradientButton()
            button.isFeedExists = participant.isFeedExists
            updateParticipantButton(userName: participant.userName, isFeedExists: participant.isFeedExists, button: button, imageURLString: participant.profileImageURL, index: index)

            applyParticipantButtonStyle(button: button, isFeedExists: participant.isFeedExists, isSelected: false)

            participantStackView.addArrangedSubview(button)
            button.layoutIfNeeded()
        }

        layoutIfNeeded()

        // 첫 번째 버튼 선택 적용 (초기 상태)
        if let firstButton = participantStackView.arrangedSubviews.first as? GradientButton {
            updateSelectedButton(firstButton)
        }
    }

    func updateParticipantButton(userName: String, isFeedExists: Bool, button: UIButton, imageURLString: String, index: Int) {
        let profileImage = RoundImageView()
        profileImage.kf.setImage(with: URL(string: imageURLString))
        profileImage.clipsToBounds = true
        button.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 5))
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 26))
        }
        
        let userNameLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: userName, textColor: .black22))
        button.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(LayoutAdapter.shared.scale(value: 6))
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.centerY.equalToSuperview()
        }
        
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 37) / 2
        button.clipsToBounds = true
        button.tag = index // 참가자의 인덱스를 태그로 저장
        
        // 버튼 클릭 이벤트
        button.addTarget(self, action: #selector(didTapParticipantButton(_:)), for: .touchUpInside)
                    
        participantStackView.addArrangedSubview(button)
        button.layoutIfNeeded()
    }
    
    func applyParticipantButtonStyle(button: GradientButton, isFeedExists: Bool, isSelected: Bool) {
        button.layer.sublayers?.filter { $0.name == "gradientBackground" }.forEach { $0.removeFromSuperlayer() }

        if isSelected {
            // ✅ 작성 + 선택됨
            button.applyGradientBackground(colors: [
                UIColor.rgb(red: 187, green: 158, blue: 255).cgColor,
                UIColor.rgb(red: 122, green: 93, blue: 249).cgColor
            ])
            button.layer.borderWidth = 0
            button.setTitleColor(.white, for: .normal)
        } else {
            if isFeedExists {
                // ✅ 작성 + 미선택
                button.backgroundColor = .brandHighLight1 // 연보라
                button.layer.borderWidth = 0
                button.setTitleColor(.black22, for: .normal)
            } else {
                // ✅ 미작성 + 미선택
                button.backgroundColor = .blackF0
                button.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
                button.layer.borderWidth = 1
                button.setTitleColor(.black22, for: .normal)
            }
        }
    }

    private func updateSelectedButton(_ button: GradientButton) {
        // 이전 선택된 버튼 스타일 리셋
        if let prevButton = selectedButton {
            applyParticipantButtonStyle(button: prevButton, isFeedExists: prevButton.isFeedExists, isSelected: false)
        }

        // 새로 선택된 버튼 스타일 적용
        applyParticipantButtonStyle(button: button, isFeedExists: button.isFeedExists, isSelected: true)

        selectedButton = button
    }
    
    func performSelectAction(for button: GradientButton) {
        updateSelectedButton(button)
        delegate?.didSelectParticipant(at: button.tag)
    }
    
    @objc private func didTapParticipantButton(_ sender: GradientButton) {
        updateSelectedButton(sender)

        let index = sender.tag
        delegate?.didSelectParticipant(at: index) // 선택된 참가자 인덱스를 델리게이트로 전달
    }
}
