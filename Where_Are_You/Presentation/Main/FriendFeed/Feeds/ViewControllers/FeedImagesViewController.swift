//
//  FeedImagesViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 13/8/2024.
//

import UIKit

class FeedImagesViewController: UIViewController {
    // MARK: - Properties
    var images: [UIImage] = []
    
    let feedImagesView = FeedImagesView()
    var viewModel: FeedDetailViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(feedImagesView)
        viewModel = FeedDetailViewModel()
        
        setupBindings()
        setupCollectionView()
    }
    
    // MARK: - Helpers
    private func setupBindings() {
        viewModel.onFeedImagesUpdated = { [weak self] images in
            DispatchQueue.main.async {
                
            }
        }
        
        // 페이지 인덱스 변경에 대한 바인딩
        viewModel.onCurrentImageIndexChanged = { [weak self] index in
            guard let self = self, self.images.indices.contains(index) else { return }
            let totalPages = self.images.count
            DispatchQueue.main.async {
                self.feedImagesView.pageControl.numberOfPages = totalPages
                self.feedImagesView.pageControl.currentPage = index
                self.feedImagesView.pageNumberLabel.text = "\(index + 1) / \(totalPages)"
            }
        }
    }
    
    private func setupCollectionView() {
        feedImagesView.collectionView.dataSource = self
        feedImagesView.collectionView.delegate = self
    }
    
    func updateImages(_ newImages: [UIImage]) {
        self.images = newImages
        feedImagesView.collectionView.reloadData()
    }
    
    private func scrollToInitialPosition() {
        let initialIndexPath = IndexPath(item: 1, section: 0) // Start at the first actual item
        feedImagesView.collectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
        viewModel.setCurrentFeedIndex(0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        viewModel.updateImageIndex(to: pageIndex)
    }
    
    // MARK: - Selectors
    
    @objc private func scrollToFeedImagesIndex(_ notification: Notification) {
        if let userInfo = notification.userInfo, let indexPath = userInfo["indexPath"] as? IndexPath {
            feedImagesView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            viewModel.setCurrentFeedIndex(indexPath.item)
            feedImagesView.pageControl.currentPage = viewModel.currentImageIndex
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FeedImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCollectionViewCell.identifier, for: indexPath) as? FeedImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: images[indexPath.item])
        return cell
    }
}
