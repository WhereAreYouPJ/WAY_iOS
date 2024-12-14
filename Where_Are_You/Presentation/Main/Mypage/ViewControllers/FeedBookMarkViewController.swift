//
//  FeedBookMarkViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import UIKit

class FeedBookMarkViewController: UIViewController {
    // MARK: - Properties
    private let feedBookMarkView = FeedBookMarkView()
    private let noDataView: NoDataView = {
        let view = NoDataView()
        view.descriptionLabel.text = "아직은 피드에 책갈피를 하지 않았어요. \n특별한 추억을 오래도록 기억할 수 있게 \n피드를 책갈피 해보세요!"
        return view
    }()
    
    var viewModel: FeedBookMarkViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
        setupTableView()
        setupBindings()
        viewModel.fetchBookMarkFeed()
        
        feedBookMarkView.updateContentHeight()
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "피드 책갈피", backButtonAction: #selector(backButtonTapped), showBackButton: true)
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
                    self?.feedBookMarkView.updateContentHeight()
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
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}
// MARK: - FeedsTableViewCellDelegate

extension FeedBookMarkViewController: FeedsTableViewCellDelegate {
    func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool) {
        viewModel.deleteBookMarkFeed(feedSeq: feedSeq)
        // 북마크 상태 변경 후 해당 셀만 업데이트
        if let index = viewModel.displayBookMarkFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
            let indexPath = IndexPath(row: index, section: 0)
            feedBookMarkView.feedsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect) {
        let isAuthor = feed.memberSeq == UserDefaultsManager.shared.getMemberSeq()
//        guard let feedSeq = feed.feedSeq else { return }
//        showFeedOptions(
//            feed: feed,
//            isAuthor: isAuthor,
//            currentViewType: .bookMark,
//            deleteAction: { self.viewModel.deleteBookMarkFeed(feedSeq: feedSeq) },
//            editAction: { self.editFeed(feed) },
//            hideAction: { self.viewModel.hidFeed(feedSeq: feedSeq) },
//            restoreAction: {}
//        )
    }
    
    private func editFeed(_ feed: Feed) {
        // 피드 수정 화면으로 이동
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
