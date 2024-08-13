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
    private let feedsView = FeedsView()
    private let noFeedsView = NoFeedsView()
    var viewModel: FeedDetailViewModel!
    private var feedImagesViewController: FeedImagesViewController!
    
    // MARK: - Lifecycle
    override func loadView() {
        viewModel = FeedDetailViewModel()
        
        setupViews()
        setupBindings()
        setupTableView()
        updateViewVisibility()
    }
    
    // MARK: - Helpers
    private func setupViews() {
        view.addSubview(feedsView)
        view.addSubview(noFeedsView)
        
        noFeedsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        feedsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            self?.updateViewVisibility()
        }
    }
    
    private func updateViewVisibility() {
        let hasFeeds = !viewModel.feeds.isEmpty
        feedsView.isHidden = !hasFeeds
        noFeedsView.isHidden = hasFeeds
        feedsView.feedsTableView.reloadData()
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
    
    private func setupTableView() {
        feedsView.feedsTableView.delegate = self
        feedsView.feedsTableView.dataSource = self
        feedsView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
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
