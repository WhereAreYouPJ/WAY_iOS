//
//  FeedBookMarkViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import UIKit

class FeedBookMarkViewController: UIViewController {
    // MARK: - Properties
    private let feedBookMarkView = FeedsView()
    private let noDataView: NoDataView = {
        let view = NoDataView()
        view.configureUI(descriptionText: "아직은 피드에 책갈피를 하지 않았어요. \n특별한 추억을 오래도록 기억할 수 있게 \n피드를 책갈피 해보세요!")
        return view
    }()
    private var optionsView = MultiCustomOptionsContainerView()

    var viewModel: FeedBookMarkViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViewModel()
        setupViews()
        setupNavigationBar()
        setupTableView()
        setupBindings()
        setupActions()
        viewModel.fetchBookMarkFeed()
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        configureNavigationBar(title: "피드 책갈피", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = FeedBookMarkViewModel(
            getBookMarkFeedUseCase: GetBookMarkFeedUseCaseImpl(feedRepository: feedRepository),
            deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCaseImpl(feedRepository: feedRepository), postHideFeedUseCase: PostHideFeedUseCaseImpl(feedRepository: feedRepository),
            deleteFeedUseCase: DeleteFeedUseCaseImpl(feedRepository: feedRepository))
    }
    
    private func setupBindings() {
        viewModel.onBookMarkFeedUpdated = { [weak self] in
            DispatchQueue.main.async {
                let isEmpty = self?.viewModel.displayBookMarkFeedContent.isEmpty ?? true
                self?.feedBookMarkView.isHidden = isEmpty
                self?.noDataView.isHidden = !isEmpty
                if !isEmpty {
                    self?.feedBookMarkView.feedsTableView.reloadData()
                }
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(feedBookMarkView)
        view.addSubview(noDataView)
        feedBookMarkView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        noDataView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        noDataView.isHidden = true
    }
    
    private func setupTableView() {
        if viewModel.displayBookMarkFeedContent.isEmpty {
            feedBookMarkView.isHidden = true
            noDataView.isHidden = false
        }
        feedBookMarkView.feedsTableView.delegate = self
        feedBookMarkView.feedsTableView.dataSource = self
        feedBookMarkView.feedsTableView.rowHeight = UITableView.automaticDimension
        feedBookMarkView.feedsTableView.estimatedRowHeight = LayoutAdapter.shared.scale(value: 498)
        feedBookMarkView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
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
            self?.viewModel.fetchBookMarkFeed()
        }
        alert.showAlert(on: self)
    }
    
    private func editFeed(_ feed: Feed) {
        print("\(feed.title) 수정")
        optionsView.removeFromSuperview()
    }
    
    private func hideFeed(_ feed: Feed) {
        let alert = CustomAlert(
            title: "피드 숨김",
            message: "피드를 숨깁니다. 숨긴 피드는 마이페이지에서 복원하거나 영구 삭제할 수 있습니다.",
            cancelTitle: "취소",
            actionTitle: "숨김"
        ) { [weak self] in
            print(feed.feedSeq)
            self?.viewModel.hideFeed(feedSeq: feed.feedSeq)
            self?.optionsView.removeFromSuperview()
            self?.viewModel.fetchBookMarkFeed()
        }
        alert.showAlert(on: self)
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !optionsView.frame.contains(location) {
            optionsView.removeFromSuperview()
        }
    }
}
// MARK: - FeedsTableViewCellDelegate

extension FeedBookMarkViewController: FeedsTableViewCellDelegate {
    func didTapReadMoreButton() {
    }
    
    func didSelectFeed(feed: Feed) {
    }
    
    func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool) {
        viewModel.deleteBookMarkFeed(feedSeq: feedSeq)
        // 북마크 상태 변경 후 해당 셀만 업데이트
        if let index = viewModel.displayBookMarkFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
            let indexPath = IndexPath(row: index, section: 0)
            feedBookMarkView.feedsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect) {
        let convertedFrame = view.convert(buttonFrame, from: nil) // ViewController 기준으로 변환
        let isAuthor = feed.memberSeq == UserDefaultsManager.shared.getMemberSeq()
        showOptions(for: feed, at: convertedFrame, isAuthor: isAuthor)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FeedBookMarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayBookMarkFeedContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsTableViewCell.identifier, for: indexPath) as? FeedsTableViewCell else {
            return UITableViewCell()
        }
        let feed = viewModel.displayBookMarkFeedContent[indexPath.row]
        cell.configure(with: feed)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FeedBookMarkViewController: FeedBookMarkViewModelDelegate {
    func didUpdateBookMarkFeed() {
        feedBookMarkView.feedsTableView.reloadData()
    }
}
