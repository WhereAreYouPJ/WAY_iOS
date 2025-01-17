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
    
    var representFeed: Feed
    var displayFeed: Feed?
    var viewModel: FeedDetailViewModel!

    // MARK: - Lifecycle
    init(feed: Feed) {
        self.representFeed = feed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let scheduleSeq = representFeed.scheduleSeq else { return }
        viewModel.fetchDetailFeeds(scheduleSeq: scheduleSeq, participantsMemberSeq: UserDefaultsManager.shared.getMemberSeq())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedDetailView.delegate = self
        feedDetailView.delegate2 = self
        setupNavigationBar()
        setupViewModel()
        fetchParticipants()

        setupBindings()
        setupView()
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
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            self?.fetchParticipants()
        }
    }
    
    private func setupView() {
        view.addSubview(feedDetailView)
        feedDetailView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        feedDetailView.configureFeedView(feed: representFeed)
    }
    
    private func fetchParticipants() {
        // 참가자 정보 로드 (뷰 모델 혹은 네트워크 호출)
        let participants = viewModel.getParticipants()
        feedDetailView.configureParticipants(participants: participants)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension FeedDetailViewController: FeedParticipantDelegate {
    func didSelectParticipant(at index: Int) {
        let displayFeed = viewModel.getParticipantFeed(index: index)
        feedDetailView.configureFeedView(feed: displayFeed)
    }
}

extension FeedDetailViewController: CommonFeedViewDelegate {
    func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool) {
        
    }
    
    func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect) {
        
    }
}
