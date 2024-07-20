//
//  BannerViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class BannerViewController: UIViewController {
    let bannerView = BannerView()
    var viewModel: BannerViewModel!
    
    override func loadView() {
        view = bannerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BannerViewModel()
        setupBindings()
        setupCollectionView()
        viewModel.fetchBannerImages()
        
        // NotificationCenter를 통해 알림을 수신하는 옵저버를 추가합니다.
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
    }
    
    // MARK: - Selectors

    @objc private func scrollToBannerIndex(_ notification: Notification) {
        if let userInfo = notification.userInfo, let indexPath = userInfo["indexPath"] as? IndexPath {
            let correctedIndex = IndexPath(item: (indexPath.item + viewModel.getBannerImages().count) % (viewModel.getBannerImages().count + 2), section: 0)
            bannerView.collectionView.scrollToItem(at: correctedIndex, at: .centeredHorizontally, animated: true)
            bannerView.pageControl.currentPage = correctedIndex.item % viewModel.getBannerImages().count
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
        let correctedIndex = (indexPath.item + images.count) % (images.count + 2)
        cell.configure(with: images[correctedIndex % images.count])
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
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.startAutoScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = bannerView.collectionView.frame.size.width
        let currentPage = Int(bannerView.collectionView.contentOffset.x / pageWidth)
        
        let imagesCount = viewModel.getBannerImages().count
        if currentPage == 0 {
            let newIndexPath = IndexPath(item: imagesCount, section: 0)
            bannerView.collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
        } else if currentPage == imagesCount + 1 {
            let newIndexPath = IndexPath(item: 1, section: 0)
            bannerView.collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
}
