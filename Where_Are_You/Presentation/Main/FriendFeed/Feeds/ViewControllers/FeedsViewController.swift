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
    var viewModel: FeedViewModel!
    private var feedImagesViewController: FeedImagesViewController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FeedsViewController - viewDidLoad() called") // 확인 로그
        print("Is viewModel nil? \(viewModel == nil)") // viewModel nil 여부 확인

        setupViewModel()
        print("Is viewModel nil after setupViewModel? \(viewModel == nil)") // viewModel 초기화 여부 확인

        setupViews()
        setupTableView()

        setupBindings()
        
        updateViewVisibility()
        addFeedImagesViewController()
        
        print("Calling fetchFeeds()")

        viewModel.fetchFeeds()
    }
    
    // MARK: - Helpers
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = FeedViewModel(getFeedListUseCase: GetFeedListUseCaseImpl(feedRepository: feedRepository))
    }
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.updateViewVisibility()
                self?.feedsView.feedsTableView.reloadData()
            }
        }
    }
//    private func updateViewVisibility() {
//        let hasFeeds = !viewModel.feeds.isEmpty
//        
//        // 기존 뷰 제거
//        feedsView?.removeFromSuperview()
//        noFeedsView?.removeFromSuperview()
//        
//        // 피드 데이터에 따라 적절한 뷰 추가
//        if hasFeeds {
//            addFeedsView()
//        } else {
//            addNoFeedsView()
//        }
//    }
    private func setupViews() {
        feedsView = FeedsView()
        noFeedsView = NoDataView()

        view.addSubview(feedsView)
        view.addSubview(noFeedsView)

        feedsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noFeedsView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupTableView() {
        feedsView.feedsTableView.delegate = self
        feedsView.feedsTableView.dataSource = self
        feedsView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
    }
    
    private func updateViewVisibility() {
        let hasFeeds = !viewModel.displayFeedContent.isEmpty
        feedsView.isHidden = !hasFeeds
//        feedsView.isHidden = false
//        noFeedsView.isHidden = true
        noFeedsView.isHidden = hasFeeds
    }
//    private func addFeedsView() {
//        feedsView = FeedsView()
//        view.addSubview(feedsView!)
//        
//        feedsView!.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    
//    private func addNoFeedsView() {
//        noFeedsView = NoDataView()
//        view.addSubview(noFeedsView!)
//        
//        noFeedsView!.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
    private func addFeedImagesViewController() {
        feedImagesViewController = FeedImagesViewController()
        addChild(feedImagesViewController)
        view.addSubview(feedImagesViewController.view)
        feedImagesViewController.didMove(toParent: self)
        
        feedImagesViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayFeedContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsTableViewCell.identifier, for: indexPath) as? FeedsTableViewCell else {
            return UITableViewCell()
        }
        let feed = viewModel.displayFeedContent[indexPath.row]
        cell.configure(with: feed)
        return cell
    }
}
