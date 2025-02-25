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
        weak var delegate2: CommonFeedViewDelegate?
            
        let participantsBoxView = FeedParticipantView()
        let feedDetailView = CommonFeedView()
        let noFeedView: NoDataView = {
            let view = NoDataView()
            view.configureUI(descriptionText: "아직은 기록하지 않은 것 같아요. \n특별한 추억을 오래도록 기억할 수 있게 \n서로에게 얘기해보세요!")
            return view
        }()
        
        // MARK: - Lifecycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            noFeedView.isHidden = true
            configureViewComponents()
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Helpers
        private func configureViewComponents() {
            addSubview(noFeedView)
            addSubview(participantsBoxView)
            addSubview(feedDetailView)
        }
        
        private func setupConstraints() {
            participantsBoxView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
                make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
                make.height.equalTo(LayoutAdapter.shared.scale(value: 37))
            }
            
            feedDetailView.snp.makeConstraints { make in
                make.top.equalTo(participantsBoxView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
                make.centerX.equalToSuperview()
                make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
                //            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
            }
            
            noFeedView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        func configureParticipants(participants: [Info]) {
            participantsBoxView.configureParticipantImages(participants: participants, delegate: self)
        }
        
        func configureFeedView(feed: Feed) {
            feedDetailView.configure(with: feed, delegate: self)
        }
        
        func showNoFeedView() {
            noFeedView.isHidden = false
            feedDetailView.isHidden = true
        }
        
        func showFeedView(feed: Feed) {
            configureFeedView(feed: feed)
            noFeedView.isHidden = true
            feedDetailView.isHidden = false
        }
    }

    extension FeedDetailView: FeedParticipantDelegate {
        func didSelectParticipant(at index: Int) {
            delegate?.didSelectParticipant(at: index) // FeedDetailViewController로 전달
        }
    }

    extension FeedDetailView: CommonFeedViewDelegate {
        func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool) {
            delegate2?.didTapBookmarkButton(feedSeq: feedSeq, isBookMarked: isBookMarked)
        }
        
        func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect) {
            delegate2?.didTapFeedFixButton(feed: feed, buttonFrame: buttonFrame)
        }
    }
