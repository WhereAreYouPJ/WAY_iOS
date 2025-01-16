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
    var viewModel: HomeFeedViewModel
    
    // MARK: - Initializer
    init(viewModel: HomeFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = feedView
        setupBindings()
        setupCollectionView()
        fetchInitialFeeds()
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
    
    private func fetchInitialFeeds() {
        viewModel.fetchFeeds { [weak self] feeds in
            DispatchQueue.main.async {
                self?.feedView.feeds = feeds
                self?.feedView.collectionView.reloadData()                
            }
        }
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
            let profileImageURL = UserDefaultsManager.shared.getProfileImage()
            cell.configureCell(profileImageURL: profileImageURL)
            cell.delegate = self
            return cell
        }
    }
}

extension HomeFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let feedCount = viewModel.getFeeds().count
        if indexPath.item < feedCount {
            let feed = viewModel.getFeeds()[indexPath.item]
            var height: CGFloat = 0
            height += LayoutAdapter.shared.scale(value: 56) // 프로필 이미지 높이
            if let content = feed.content, !content.isEmpty {
                height += LayoutAdapter.shared.scale(value: 40) // 피드 content 높이
            } else {
                height -= LayoutAdapter.shared.scale(value: 12) // 피드 content 위 아래 padding 삭제(content가 없는 조건)
            }
            
            height += LayoutAdapter.shared.scale(value: 80) // 피드 이미지뷰 높이
            height += LayoutAdapter.shared.scale(value: 56) // 피드 여백 높이
            return CGSize(width: feedView.frame.width - 30, height: height)
        } else {
            return CGSize(width: LayoutAdapter.shared.scale(value: 270), height: LayoutAdapter.shared.scale(value: 160))
        }
    }
}

extension HomeFeedViewController: MoreFeedCollectionViewCellDelegate {
    func didTapMoreButton() {
        // 더보기 버튼 눌러서 전체 피드 뷰 컨트롤러로 이동
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
}
