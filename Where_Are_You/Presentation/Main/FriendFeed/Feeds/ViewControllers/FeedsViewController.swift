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
    
    // MARK: - Lifecycle
    override func loadView() {
        viewModel = FeedDetailViewModel()
        view = UIView()
        view.addSubview(feedsView)
        view.addSubview(noFeedsView)
        setupBindings()
        setupTableView()
        updateViewVisibility()
        configureConstraints()
    }
    
    // MARK: - Helpers
    
    private func configureConstraints() {
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
    
    private func setupTableView() {
        feedsView.feedsTableView.delegate = self
        feedsView.feedsTableView.dataSource = self
        feedsView.feedsTableView.register(FeedsTableViewCell.self, forCellReuseIdentifier: FeedsTableViewCell.identifier)
    }
    
    private func updateViewVisibility() {
        let hasFeeds = !viewModel.feeds.isEmpty
        feedsView.isHidden = !hasFeeds
        noFeedsView.isHidden = hasFeeds
        if hasFeeds {
            feedsView.feedsTableView.reloadData()
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
        
        cell.feedImageView.isHidden = feed.feedImages == nil
        cell.descriptionLabel.isHidden = feed.description == nil
        cell.detailBox.titleLabel.text = feed.title
        cell.detailBox.dateLabel.text = feed.date?.description
        cell.detailBox.locationLabel.text = feed.location
        cell.detailBox.profileImage.image = feed.profileImage
        
        return cell
    }
}
