//
//  BannerViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class BannerViewController: UIViewController {
    // MARK: - Properties

    let bannerView = BannerView()
    var viewModel: BannerViewModel!
    
    // MARK: - Lifecycle

    override func loadView() {
        view = bannerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BannerViewModel()
        setupBindings()
        setupCollectionView()
        viewModel.fetchBannerImages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToBannerIndex(_:)), name: .scrollToBannerIndex, object: nil)
    }
    
    // MARK: - Helpers
    
    private func setupBindings() {
        viewModel.onBannerDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.bannerView.collectionView.reloadData()
                self?.scrollToInitialPosition()
            }
        }
    }
    
    private func setupCollectionView() {
        bannerView.collectionView.dataSource = self
        bannerView.collectionView.delegate = self
    }
    
    private func scrollToInitialPosition() {
        let initialIndexPath = IndexPath(item: 1, section: 0) // Start at the first actual item
        bannerView.collectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
        viewModel.updateCurrentIndex(to: 0)
        updatePageNumber()
    }
    
    private func updatePageNumber() {
        let currentPage = viewModel.currentIndex + 1
        let totalPages = viewModel.getBannerImages().count
        bannerView.pageNumberLabel.text = "\(currentPage) / \(totalPages)"
        print("Page Number Updated: \(currentPage) / \(totalPages)") // 디버그 로그
    }
    
    // MARK: - Selectors
    
    @objc private func scrollToBannerIndex(_ notification: Notification) {
        if let userInfo = notification.userInfo, let indexPath = userInfo["indexPath"] as? IndexPath {
            bannerView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            viewModel.updateCurrentIndex(to: indexPath.item - 1) // -1 to adjust for fake cells
            bannerView.pageControl.currentPage = viewModel.currentIndex
            updatePageNumber()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UICollectionViewDataSource

extension BannerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getBannerImages().count + 2 // +2 페이크 셀
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
            fatalError("Unable to dequeue BannerCollectionViewCell")
        }
        let images = viewModel.getBannerImages()
        let correctedIndex = (indexPath.item - 1 + images.count) % images.count
        cell.configure(with: images[correctedIndex])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BannerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.stopAutoScroll()
        print("Scroll View Will Begin Dragging") // 디버그 로그
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.startAutoScroll()
        print("Scroll View Did End Dragging") // 디버그 로그
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = bannerView.collectionView.frame.size.width
        let currentPage = Int(bannerView.collectionView.contentOffset.x / pageWidth)
        print("Current Page: \(currentPage)") // 디버그 로그
        
        let imagesCount = viewModel.getBannerImages().count
        if currentPage == 0 {
            let newIndexPath = IndexPath(item: imagesCount, section: 0)
            bannerView.collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
            viewModel.updateCurrentIndex(to: imagesCount - 1)
        } else if currentPage == imagesCount + 1 {
            let newIndexPath = IndexPath(item: 1, section: 0)
            bannerView.collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
            viewModel.updateCurrentIndex(to: 0)
        } else {
            viewModel.updateCurrentIndex(to: currentPage - 1)
        }
        bannerView.pageControl.currentPage = viewModel.currentIndex
        updatePageNumber()
    }
}
