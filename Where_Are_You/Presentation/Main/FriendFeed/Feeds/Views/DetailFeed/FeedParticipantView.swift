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
        }
    }
    
    func configureParticipantImages(participants: [Info], delegate: FeedParticipantDelegate?) {
        self.delegate = delegate
        
        participantStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, participant) in participants.enumerated() {
            let button = UIButton()
            let profileImage = UIImageView()
            profileImage.kf.setImage(with: URL(string: participant.profileImageURL))
            profileImage.layer.cornerRadius = 14
            profileImage.clipsToBounds = true
            button.addSubview(profileImage)
            profileImage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
                make.width.height.equalTo(LayoutAdapter.shared.scale(value: 28))
                make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 4))
            }
            let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: participant.userName, textColor: .color34, fontSize: 12)
            button.addSubview(userNameLabel)
            userNameLabel.snp.makeConstraints { make in
                make.leading.equalTo(profileImage.snp.trailing).offset(LayoutAdapter.shared.scale(value: 2))
                make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
                make.centerY.equalToSuperview()
            }
            button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 20)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.color240.cgColor
            button.clipsToBounds = true
            button.tag = index // 참가자의 인덱스를 태그로 저장
            
            // 버튼 클릭 이벤트
            button.addTarget(self, action: #selector(didTapParticipantButton(_:)), for: .touchUpInside)
            
            participantStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func didTapParticipantButton(_ sender: UIButton) {
        let index = sender.tag
        delegate?.didSelectParticipant(at: index) // 선택된 참가자 인덱스를 델리게이트로 전달
    }
}
