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
    let plusOptionButton = CustomOptionButtonView(title: "새 피드 작성")
    
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
        
        //        viewModel.onImageLoaded = { [weak self] feedSeq in
        //            DispatchQueue.main.async {
        //                let indexPath = IndexPath(row: feedSeq, section: 0)
        //                if let cell = self?.feedsView.feedsTableView.cellForRow(at: indexPath) as? FeedsTableViewCell {
        //                    if let image = self?.viewModel.image(for: feedSeq, at: 0) {
        //                        cell.feedImagesView.collectionView.reloadData()
        //                    }
        //                }
        //            }
        //        }
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
        plusOptionButton.button.addTarget(self, action: #selector(plusOptionButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Selectors
    
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !plusOptionButton.frame.contains(location) {
            plusOptionButton.isHidden = true
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
    func didTapFixButton(feedSeq: Int, isOwner: Bool) {
        if isOwner {
            // 내가 작성한 피드
        } else {
            // 남이 작성한 피드
            let optionButton = CustomOptionButtonView(title: "피드 숨김")
        }
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
