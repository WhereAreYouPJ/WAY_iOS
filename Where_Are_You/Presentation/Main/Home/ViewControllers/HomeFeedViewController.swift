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
        viewModel.fetchFeeds()
    }
    
    // MARK: - Helpers
    
    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.feedView.feeds = self?.viewModel.getFeeds() ?? []
            }
        }
    }
    
    private func setupCollectionView() {
        feedView.collectionView.dataSource = self
        feedView.collectionView.delegate = self
        feedView.collectionView.register(HomeFeedCollectionViewCell.self, forCellWithReuseIdentifier: HomeFeedCollectionViewCell.identifier)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension HomeFeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getFeeds().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.identifier, for: indexPath) as? HomeFeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        let feed = viewModel.getFeeds()[indexPath.item]
        cell.configure(with: feed)
        return cell
    }
}
