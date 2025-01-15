//
//  FeedsDetailViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/12/2024.
//

import UIKit

class FeedDetailViewController: UIViewController {
    // MARK: - Properties
    private let feedDetailView = FeedDetailView()
    
    private var optionsView = MultiCustomOptionsContainerView()
    
    var feed: Feed
    private var participants: [Info] = [] // 참가자 정보
    
    // MARK: - Lifecycle
    init(feed: Feed) {
        self.feed = feed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedDetailView.delegate = self
        
        setupView()
        configureView()
        fetchParticipants()
    }
    
    // MARK: - Helpers
    private func setupView() {
        view.addSubview(feedDetailView)
        feedDetailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        
    }
    
    private func fetchParticipants() {
        // 참가자 정보 로드 (뷰 모델 혹은 네트워크 호출)
        // 예제 코드
        participants = feed.scheduleFriendInfos ?? []
        sortParticipants()
        feedDetailView.configureParticipants(participants: participants)
    }
    
    private func sortParticipants() {
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
//        participants.sort { $0.memberSeq == memberSeq } // 내가 작성한 피드 우선 배치
    }
}

extension FeedDetailViewController: FeedParticipantDelegate {
    func didSelectParticipant(at index: Int) {
        print("Participant selected at index: \(index)")
        // Implement logic to display the selected participant's feed
    }
}
