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
    var viewModel: BannerViewModel
    
    // MARK: - Initializer
    init(viewModel: BannerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = bannerView

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
                self?.updatePageNumber()
            }
        }
    }
    
    private func setupCollectionView() {
        bannerView.collectionView.dataSource = self
        bannerView.collectionView.delegate = self
        bannerView.collectionView.register(BannerCollectionViewCell.self,
                                           forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
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
        bannerView.pageNumberLabel.updateTextKeepingAttributes(newText: "\(currentPage) / \(totalPages)") 
    }
    
    // 배너 이미지를 업데이트하는 메서드 추가
    func updateBannerImages(_ images: [UIImage]) {
        viewModel.setBannerImages(images)
    }
    
    // MARK: - Selectors
    
    @objc private func scrollToBannerIndex(_ notification: Notification) {
        if let userInfo = notification.userInfo, let indexPath = userInfo["indexPath"] as? IndexPath {
            bannerView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            viewModel.updateCurrentIndex(to: indexPath.item - 1) // -1 to adjust for fake cells
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
            
            // 배열이 비어있는 경우를 처리합니다.
            if images.isEmpty {
                // 예를 들어, 빈 셀에 대한 기본 이미지를 설정하거나 처리할 수 있습니다.
                cell.configure(with: UIImage()) // 빈 이미지 또는 기본 이미지
            } else {
                let correctedIndex = (indexPath.item - 1 + images.count) % images.count
                cell.configure(with: images[correctedIndex])
            }
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
            viewModel.updateCurrentIndex(to: imagesCount - 1)
        } else if currentPage == imagesCount + 1 {
            let newIndexPath = IndexPath(item: 1, section: 0)
            bannerView.collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
            viewModel.updateCurrentIndex(to: 0)
        } else {
            viewModel.updateCurrentIndex(to: currentPage - 1)
        }
        updatePageNumber()
    }
}
