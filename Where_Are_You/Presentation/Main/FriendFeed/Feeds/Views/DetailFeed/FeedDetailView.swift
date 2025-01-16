//
//  FeedDetailView.swift
//  Where_Are_You
//
//  Created by 오정석 on 14/1/2025.
//

import UIKit
import Kingfisher

class FeedDetailView: UIView {
    // MARK: - Properties
    weak var delegate: FeedParticipantDelegate?

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
    
    func configureParticipants(participants: [Info]) {
        participantsBoxView.configureParticipantImages(participants: participants, delegate: self)
    }
    
    // MARK: - Selectors
    

}

extension FeedDetailView: FeedParticipantDelegate {
    func didSelectParticipant(at index: Int) {
        delegate?.didSelectParticipant(at: index) // FeedDetailViewController로 전달
    }
}
