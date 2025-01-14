//
//  FeedDetailView.swift
//  Where_Are_You
//
//  Created by 오정석 on 14/1/2025.
//

import UIKit
import Kingfisher

protocol FeedDetailDelegate: AnyObject {
    func didSelectParticipant(at index: Int)
}

class FeedDetailView: UIView {
    // MARK: - Properties
    weak var delegate: FeedDetailDelegate?
    
    let participantsBoxView = FeedParticipantView()
    let feedsView = FeedsView()
    
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
        addSubview(participantsBoxView)
        addSubview(feedsView)
    }
    
    private func setupConstraints() {
        participantsBoxView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 18))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        feedsView.snp.makeConstraints { make in
            make.top.equalTo(participantsBoxView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
        }
    }
    
    func configureParticipantImages(participants: [Info]) {
        participantsBoxView.participantStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, participant) in participants.enumerated() {
            let button = UIButton()
            let profileImage = UIImageView()
            profileImage.kf.setImage(with: URL(string: participant.profileImageURL))
            let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: participant.userName, textColor: .color34, fontSize: 12)
            button.addSubview(profileImage)
            button.addSubview(userNameLabel)
            profileImage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
                make.width.height.equalTo(LayoutAdapter.shared.scale(value: 28))
                make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 4))
            }
            userNameLabel.snp.makeConstraints { make in
                make.leading.equalTo(profileImage.snp.trailing).offset(LayoutAdapter.shared.scale(value: 2))
                make.centerY.equalToSuperview()
            }
            button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 12)
            button.clipsToBounds = true
            button.tag = index // 참가자의 인덱스를 태그로 저장
            
            // 버튼 클릭 이벤트
            button.addTarget(self, action: #selector(didTapParticipantButton(_:)), for: .touchUpInside)
            
            participantsBoxView.participantStackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Selectors

    @objc private func didTapParticipantButton(_ sender: UIButton) {
        let index = sender.tag
        delegate?.didSelectParticipant(at: index) // 선택된 참가자 인덱스를 델리게이트로 전달
    }
}
