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
    var plusOptionButton = CustomOptionButtonView(title: "새 피드 작성", image: nil)

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
        viewModel.fetchDetailFeeds(scheduleSeq: scheduleSeq)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedDetailView.delegate = self
        feedDetailView.delegate2 = self
        
        setupNavigationBar()
        setupViewModel()
        fetchParticipants()
        setupView()
        setupBindings()
        setupActions()
        
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        configureNavigationBar(title: "", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = FeedDetailViewModel(
            getFeedDetailsUseCase: GetFeedDetailsUseCaseImpl(feedRepository: feedRepository),
            deleteFeedUseCase: DeleteFeedUseCaseImpl(feedRepository: feedRepository),
            postHideFeedUseCase: PostHideFeedUseCaseImpl(feedRepository: feedRepository),
            postBookMarkFeedUseCase: PostBookMarkFeedUseCaseImpl(feedRepository: feedRepository),
            deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCaseImpl(feedRepository: feedRepository))
    }
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            self?.fetchParticipants()
        }
    }
    
    private func setupView() {
        view.addSubview(feedDetailView)
        feedDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        plusOptionButton.isHidden = true
        view.addSubview(plusOptionButton)
        
        plusOptionButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 9))
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 15))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 160))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 38))
        }
        feedDetailView.configureFeedView(feed: representFeed)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
        plusOptionButton.button.addTarget(self, action: #selector(plusOptionButtonTapped), for: .touchUpInside)
    }
    
    private func fetchParticipants() {
        // 참가자 정보 로드 (뷰 모델 혹은 네트워크 호출)
        let participants = viewModel.getParticipants()
        feedDetailView.configureParticipants(participants: participants)
        
        // representFeed의 작성자가 몇 번째인지 찾음
        let memberSeq = representFeed.memberSeq
        if let selectedIndex = participants.firstIndex(where: { $0.memberSeq == memberSeq }) {
            feedDetailView.selectParticipant(at: selectedIndex)
        }
    }
    
    private func showOptions(for feed: Feed, at frame: CGRect, isAuthor: Bool) {
        optionsView.removeFromSuperview()
        
        optionsView = FeedOptionsHandler.showOptions(
            in: self.view,
            frame: frame,
            isAuthor: isAuthor,
            isArchive: false,
            feed: feed,
            deleteAction: { self.deleteFeed(feed) },
            editAction: { self.editFeed(feed) },
            hideAction: { self.hideFeed(feed) }
        )
    }
    
    private func deleteFeed(_ feed: Feed) {
        let alert = CustomAlert(
            title: "피드 삭제",
            message: "친구의 피드는 유지되며, 자신의 피드만 영구적으로 삭제됩니다.",
            cancelTitle: "취소",
            actionTitle: "삭제"
        ) { [weak self] in
            self?.viewModel.deleteFeed(feedSeq: feed.feedSeq)
            self?.optionsView.removeFromSuperview()
            self?.feedDetailView.showNoFeedView()
        }
        alert.showAlert(on: self)
    }
    
    private func editFeed(_ feed: Feed) {
        print("\(feed.title) 수정")
        optionsView.removeFromSuperview()
        let controller = EditFeedViewController(feed: feed)
        controller.onFeedEdited = { [weak self] in
            guard let scheduleSeq = feed.scheduleSeq else { return }
            self?.viewModel.fetchDetailFeeds(scheduleSeq: scheduleSeq)
        }
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    private func hideFeed(_ feed: Feed) {
        let alert = CustomAlert(
            title: "피드 숨김",
            message: "피드를 숨깁니다. 숨긴 피드는 마이페이지에서 복원하거나 영구 삭제할 수 있습니다.",
            cancelTitle: "취소",
            actionTitle: "숨김"
        ) { [weak self] in
            self?.viewModel.hideFeed(feedSeq: feed.feedSeq)
            self?.optionsView.removeFromSuperview()
            self?.feedDetailView.showNoFeedView()
            guard let scheduleSeq = feed.scheduleSeq else { return }
            self?.viewModel.fetchDetailFeeds(scheduleSeq: scheduleSeq)
        }
        alert.showAlert(on: self)
    }
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !plusOptionButton.frame.contains(location) {
            plusOptionButton.isHidden = true
        }
        
        if !optionsView.frame.contains(location) {
            optionsView.removeFromSuperview()
        }
    }
    
    @objc func plusOptionButtonTapped() {
        plusOptionButton.isHidden = true
        let controller = AddFeedViewController()
        controller.onFeedCreated = { [weak self] in
            guard let scheduleSeq = self?.representFeed.scheduleSeq else { return }
            self?.viewModel.fetchDetailFeeds(scheduleSeq: scheduleSeq)
        }
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

extension FeedDetailViewController: FeedParticipantDelegate {
    func didSelectParticipant(at index: Int) {
        if viewModel.hasParticipantFeed(index: index) {
            guard let displayFeed = viewModel.getParticipantFeed(index: index) else { return }
            feedDetailView.showFeedView(feed: displayFeed)
        } else {
            // 작성된 피드가 없는 경우
            feedDetailView.showNoFeedView()
        }
    }
}

extension FeedDetailViewController: CommonFeedViewDelegate {
    func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect) {
        let isAuthor = feed.memberSeq == UserDefaultsManager.shared.getMemberSeq()
        showOptions(for: feed, at: buttonFrame, isAuthor: isAuthor)
    }
    
    func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool) {
        if isBookMarked {
            viewModel.postFeedBookMark(feedSeq: feedSeq)
        } else {
            viewModel.deleteFeedBookMark(feedSeq: feedSeq)
        }
    }
}
