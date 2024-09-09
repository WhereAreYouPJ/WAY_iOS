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
    private var feedsView: FeedsView?
    private var noFeedsView: NoDataView?
    var viewModel: FeedDetailViewModel!
    private var feedImagesViewController: FeedImagesViewController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedDetailViewModel()
        setupBindings()
        updateViewVisibility()
        viewModel.fetchFeeds()
    }
    
    // MARK: - Helpers
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.updateViewVisibility()
            }
        }
    }
    
    private func updateViewVisibility() {
        let hasFeeds = !viewModel.feeds.isEmpty
        
        // 기존 뷰 제거
        feedsView?.removeFromSuperview()
        noFeedsView?.removeFromSuperview()
        
        // 피드 데이터에 따라 적절한 뷰 추가
        if hasFeeds {
            addFeedsView()
        } else {
            addNoFeedsView()
        }
    }
    
    private func addFeedsView() {
        feedsView = FeedsView()
        view.addSubview(feedsView!)
        
        feedsView!.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 테이블 뷰 설정
        feedsView!.feedsTableView.delegate = self
        feedsView!.feedsTableView.dataSource = self
        feedsView!.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
        feedsView!.feedsTableView.reloadData()
    }
    
    private func addNoFeedsView() {
        noFeedsView = NoDataView()
        view.addSubview(noFeedsView!)
        
        noFeedsView!.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
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
        return viewModel.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedsTableViewCell.identifier, for: indexPath) as? FeedsTableViewCell else {
            return UITableViewCell()
        }
        let feed = viewModel.feeds[indexPath.row]
        cell.configure(with: feed)
        return cell
    }
}
