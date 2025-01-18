//
//  FeedArchiveViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/12/2024.
//

import UIKit

class FeedArchiveViewController: UIViewController {
    private let feedArchiveView = FeedsView()
    private let noDataView: NoDataView = {
        let view = NoDataView()
        view.configureUI(descriptionText: "아직은 숨긴 피드가 없어요. \n숨긴 피드는 이곳에서 복원이 가능해요.")
        return view
    }()
    private var optionsView = MultiCustomOptionsContainerView()

    var viewModel: FeedArchiveViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
        setupTableView()
        setupBindings()
        setupActions()
        setupNavigationBar()
        viewModel.fetchArchiveFeed()
        
        feedArchiveView.updateContentHeight()
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "피드 보관함", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = FeedArchiveViewModel(
            deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCaseImpl(feedRepository: feedRepository),
            deleteHideFeedUseCase: DeleteHideFeedUseCaseImpl(feedRepository: feedRepository),
            deleteFeedUseCase: DeleteFeedUseCaseImpl(feedRepository: feedRepository),
            getHideFeedUseCase: GetHideFeedUseCaseImpl(feedRepository: feedRepository))
    }
    
    private func setupBindings() {
        viewModel.onArchiveFeedUpdated = { [weak self] in
            DispatchQueue.main.async {
                let isEmpty = self?.viewModel.displayArchiveFeedContent.isEmpty ?? true
                self?.feedArchiveView.isHidden = isEmpty
                self?.noDataView.isHidden = !isEmpty
                if !isEmpty {
                    self?.feedArchiveView.feedsTableView.reloadData()
                    self?.feedArchiveView.updateContentHeight()
                }
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(feedArchiveView)
        view.addSubview(noDataView)
        feedArchiveView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        noDataView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        noDataView.isHidden = true
    }
    
    private func setupTableView() {
        if viewModel.displayArchiveFeedContent.isEmpty {
            feedArchiveView.isHidden = true
            noDataView.isHidden = false
        }
        feedArchiveView.feedsTableView.delegate = self
        feedArchiveView.feedsTableView.dataSource = self
        feedArchiveView.feedsTableView.rowHeight = UITableView.automaticDimension
        feedArchiveView.feedsTableView.estimatedRowHeight = LayoutAdapter.shared.scale(value: 498)
        feedArchiveView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
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
            isArchive: true,
            feed: feed,
            deleteAction: { self.deleteFeed(feed) },
            editAction: { self.editFeed() },
            hideAction: { self.restoreFeed(feed) }
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
        }
        alert.showAlert(on: self)
    }
    
    private func editFeed() { }
    
    private func restoreFeed(_ feed: Feed) {
        let alert = CustomAlert(
            title: "피드 복원",
            message: "피드가 정상적으로 복원되며, 피드 메뉴에서 다시 확인할 수 있습니다.",
            cancelTitle: "취소",
            actionTitle: "복원"
        ) { [weak self] in
            self?.viewModel.restoreFeed(feedSeq: feed.feedSeq)
            self?.optionsView.removeFromSuperview()
            self?.feedArchiveView.feedsTableView.reloadData()
        }
        alert.showAlert(on: self)
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !optionsView.frame.contains(location) {
            optionsView.removeFromSuperview()
        }
    }
}

// MARK: - FeedsTableViewCellDelegate

extension FeedArchiveViewController: FeedsTableViewCellDelegate {
    func didSelectFeed(feed: Feed) {
    }
    
    func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool) {
        viewModel.deleteBookMarkFeed(feedSeq: feedSeq)
        // 북마크 상태 변경 후 해당 셀만 업데이트
        if let index = viewModel.displayArchiveFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
            let indexPath = IndexPath(row: index, section: 0)
            feedArchiveView.feedsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect) {
        let convertedFrame = view.convert(buttonFrame, from: nil) // ViewController 기준으로 변환
        let isAuthor = feed.memberSeq == UserDefaultsManager.shared.getMemberSeq()
        
        showOptions(for: feed, at: convertedFrame, isAuthor: isAuthor)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FeedArchiveViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayArchiveFeedContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsTableViewCell.identifier, for: indexPath) as? FeedsTableViewCell else {
            return UITableViewCell()
        }
        let feed = viewModel.displayArchiveFeedContent[indexPath.row]
        cell.configure(with: feed)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
