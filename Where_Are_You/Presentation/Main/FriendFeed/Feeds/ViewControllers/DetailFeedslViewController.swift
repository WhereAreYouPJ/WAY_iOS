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
    var displayFeed: Feed?
    private var participants: [Info] = [] // 참가자 정보
    var viewModel: FeedDetailViewModel!

    // MARK: - Lifecycle
    init(feed: Feed) {
        self.feed = feed
        self.participants = feed.scheduleFriendInfos ?? []

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedDetailView.delegate = self
        setupNavigationBar()
        setupViewModel()
        setupView()
        configureView()
        fetchParticipants()
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        configureNavigationBar(title: "", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = FeedDetailViewModel(getFeedDetailsUseCase: GetFeedDetailsUseCaseImpl(feedRepository: feedRepository))
    }
    
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
        feedDetailView.configureParticipants(participants: participants)
        
        // 상세 피드 데이터들 다 받아오기(사용자 경험 증진을 위해)
        let participantsMemberSeq = participants.compactMap { $0.memberSeq }
        guard let scheduleSeq = feed.scheduleSeq else { return }
        viewModel.fetchDetailFeeds(scheduleSeq: scheduleSeq, participantsMemberSeq: participantsMemberSeq)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension FeedDetailViewController: FeedParticipantDelegate {
    func didSelectParticipant(at index: Int) {
        self.displayFeed = viewModel.getParticipantFeed(index: index)
    }
}
