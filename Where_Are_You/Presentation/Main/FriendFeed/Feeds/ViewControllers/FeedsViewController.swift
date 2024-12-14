//
//  FeedsViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit
import SwiftUI

class FeedsViewController: UIViewController {
    // MARK: - Properties
    private var feedsView = FeedsView()
    private var noFeedsView = NoDataView()
    var plusOptionButton = CustomOptionButtonView(title: "새 피드 작성", image: nil)
    private var optionsView = MultiCustomOptionsContainerView()
    private var selectedFeed: Feed?
    
    var viewModel: FeedViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
        setupTableView()
        setupBindings()
        setupActions()
        viewModel.fetchFeeds()
        
        feedsView.updateContentHeight()
    }
    
    // MARK: - Helpers
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = FeedViewModel(
            getFeedListUseCase: GetFeedListUseCaseImpl(feedRepository: feedRepository),
            deleteFeedUseCase: DeleteFeedUseCaseImpl(feedRepository: feedRepository),
            postHideFeedUseCase: PostHideFeedUseCaseImpl(feedRepository: feedRepository),
            postBookMarkFeedUseCase: PostBookMarkFeedUseCaseImpl(feedRepository: feedRepository),
            deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCaseImpl(feedRepository: feedRepository))
    }
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                let isEmpty = self?.viewModel.displayFeedContent.isEmpty ?? true
                self?.feedsView.isHidden = isEmpty
                self?.noFeedsView.isHidden = !isEmpty
                if !isEmpty {
                    self?.feedsView.feedsTableView.reloadData()
                    self?.feedsView.updateContentHeight()
                }
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(feedsView)
        view.addSubview(noFeedsView)
        feedsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        noFeedsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        noFeedsView.isHidden = true
        plusOptionButton.isHidden = true
        
        view.addSubview(plusOptionButton)
        
        plusOptionButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 9))
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 15))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 160))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 38))
        }
    }
    
    private func setupTableView() {
        if viewModel.displayFeedContent.isEmpty {
            feedsView.isHidden = true
            noFeedsView.isHidden = false
        }
        feedsView.feedsTableView.delegate = self
        feedsView.feedsTableView.dataSource = self
        feedsView.feedsTableView.rowHeight = UITableView.automaticDimension
        feedsView.feedsTableView.estimatedRowHeight = LayoutAdapter.shared.scale(value: 498)
        feedsView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func showOptions(for feed: Feed, at frame: CGRect, isAuthor: Bool) {
        optionsView.removeFromSuperview()
        // Configure options
        let titles: [String]
        let actions: [() -> Void]
        
        if isAuthor {
            titles = ["피드 삭제", "피드 수정", "피드 숨김"]
            actions = [
                { self.deleteFeed(feed) },
                { self.editFeed(feed) },
                { self.hideFeed(feed) }
            ]
        } else {
            titles = ["피드 숨김"]
            actions = [
                { self.hideFeed(feed) }
            ]
        }
        print("Titles: \(titles), Actions count: \(actions.count)")

        // Configure CustomOptionsContainerView
        optionsView.configureOptions(titles: titles, actions: actions)
        optionsView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 10)
        optionsView.clipsToBounds = true
        view.addSubview(optionsView)
        optionsView.snp.makeConstraints { make in
            make.top.equalTo(frame.maxY)
            make.width.equalTo(LayoutAdapter.shared.scale(value: 160))
            make.trailing.equalToSuperview().inset(11)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 90))
        }
        view.layoutIfNeeded() // 레이아웃 강제 완료
    }
    
    private func deleteFeed(_ feed: Feed) {
        guard let feedSeq = feed.feedSeq else { return }
        viewModel.deleteFeed(feedSeq: feedSeq)
        optionsView.removeFromSuperview()
        feedsView.feedsTableView.reloadData()
    }
    
    private func editFeed(_ feed: Feed) {
        print("\(feed.title) 수정")
        optionsView.removeFromSuperview()
    }
    
    private func hideFeed(_ feed: Feed) {
        guard let feedSeq = feed.feedSeq else { return }
        viewModel.hidFeed(feedSeq: feedSeq)
        optionsView.removeFromSuperview()
        feedsView.feedsTableView.reloadData()
    }
    
    // MARK: - Selectors
    
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
            self?.viewModel.fetchFeeds()
        }
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - FeedsTableViewCellDelegate

extension FeedsViewController: FeedsTableViewCellDelegate {
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
        // 북마크 상태 변경 후 해당 셀만 업데이트
        if let index = viewModel.displayFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
            let indexPath = IndexPath(row: index, section: 0)
            feedsView.feedsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(viewModel.displayFeedContent.count)")
        return viewModel.displayFeedContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsTableViewCell.identifier, for: indexPath) as? FeedsTableViewCell else {
            return UITableViewCell()
        }
        let feed = viewModel.displayFeedContent[indexPath.row]
        cell.configure(with: feed)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
