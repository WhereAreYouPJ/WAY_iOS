//
//  FeedTableViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class HomeFeedViewController: UIViewController {
    
    // MARK: - Properties
    
    let feedView = HomeFeedView()
    var viewModel: FeedViewModel!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedViewModel()
        setupBindings()
        setupCollectionView()
    }
    
    // MARK: - Helpers
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.feedView.feeds = self?.viewModel.getFeeds() ?? []
                self?.feedView.collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView() {
        feedView.collectionView.dataSource = self
        feedView.collectionView.delegate = self
        feedView.collectionView.register(HomeFeedCollectionViewCell.self, forCellWithReuseIdentifier: HomeFeedCollectionViewCell.identifier)
        feedView.collectionView.register(MoreFeedCollectionViewCell.self, forCellWithReuseIdentifier: MoreFeedCollectionViewCell.identifier)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomeFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.getFeeds().count
        return viewModel.shouldShowMoreFeedsCell() ? count + 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCount = viewModel.getFeeds().count
        if indexPath.item < feedCount {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.identifier, for: indexPath) as? HomeFeedCollectionViewCell else {
                return UICollectionViewCell()
            }
            let feed = viewModel.getFeeds()[indexPath.item]
            cell.configure(with: feed)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreFeedCollectionViewCell.identifier, for: indexPath) as? MoreFeedCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        }
    }
}

private func configureMoreFeedCell(for indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreFeedCollectionViewCell.identifier, for: indexPath) as? MoreFeedCollectionViewCell else {
        return UICollectionViewCell()
    }
    return cell
}

extension HomeFeedViewController: MoreFeedCollectionViewCellDelegate {
    func didTapMoreButton() {
        // 전체 피드 뷰 컨트롤러로 이동
        let feedsViewController = FeedsViewController()
        navigationController?.pushViewController(feedsViewController, animated: true)
    }
}
