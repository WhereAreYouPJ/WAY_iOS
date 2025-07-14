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
    
    func configureParticipantImages(participants: [Info], delegate: FeedParticipantDelegate?) {
        self.delegate = delegate
        
        participantStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, participant) in participants.enumerated() {
            // participant에서 작성했는지 안했는지 조건 확인하고 피드 작성을 안했으면 회색으로 뜨게 만들기
            // 1. 작성했다면 지금 아래의 로직 사용
            let button = GradientButton()
            
            let profileImage = RoundImageView()
            profileImage.kf.setImage(with: URL(string: participant.profileImageURL))
            profileImage.clipsToBounds = true
            button.addSubview(profileImage)
            profileImage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 5))
                make.height.width.equalTo(LayoutAdapter.shared.scale(value: 26))
            }
            
            let userNameLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: participant.userName, textColor: .black22))
            button.addSubview(userNameLabel)
            userNameLabel.snp.makeConstraints { make in
                make.leading.equalTo(profileImage.snp.trailing).offset(LayoutAdapter.shared.scale(value: 6))
                make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
                make.centerY.equalToSuperview()
            }
            
            button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 37) / 2
            button.applyGradientBorder(colors: [UIColor.rgb(red: 141, green: 103, blue: 255).cgColor, UIColor.rgb(red: 111, green: 77, blue: 215).cgColor], lineWidth: 1.5)
            button.clipsToBounds = true
            button.tag = index // 참가자의 인덱스를 태그로 저장
            
            // 버튼 클릭 이벤트
            button.addTarget(self, action: #selector(didTapParticipantButton(_:)), for: .touchUpInside)
                        
            participantStackView.addArrangedSubview(button)
            button.layoutIfNeeded()
        }
        layoutIfNeeded()
        if let firstButton = participantStackView.arrangedSubviews.first as? GradientButton {
            updateSelectedButton(firstButton)
        }
    }
    
    private func updateSelectedButton(_ button: GradientButton) {
        // 이전 버튼의 선택 상태 해제
//        selectedButton?.applyGradientBorder(colors: [UIColor.rgb(red: 141, green: 103, blue: 255).cgColor, UIColor.rgb(red: 111, green: 77, blue: 215).cgColor], lineWidth: 1.5)
        selectedButton?.layer.sublayers?.filter { $0.name == "gradientBackground" }.forEach { $0.removeFromSuperlayer() }
        
        button.applyGradientBackground(colors: [UIColor.rgb(red: 187, green: 158, blue: 255).cgColor, UIColor.rgb(red: 122, green: 93, blue: 249).cgColor])
        button.layer.borderColor = UIColor.clear.cgColor
        
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
