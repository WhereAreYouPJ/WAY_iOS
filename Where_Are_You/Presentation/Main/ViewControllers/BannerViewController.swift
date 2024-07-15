//
//  BannerViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class BannerViewController: UIViewController {
    private let bannerView = BannerView()
    private var viewModel: BannerViewModel!

    override func loadView() {
        view = bannerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BannerViewModel()
        setupBindings()
        setupCollectionView()
        viewModel.fetchBannerImages()
    }

    private func setupBindings() {
        viewModel.onBannerDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.bannerView.collectionView.reloadData()
                self?.bannerView.pageControl.numberOfPages = self?.viewModel.getBannerImages().count ?? 0
            }
        }
    }

    private func setupCollectionView() {
        bannerView.collectionView.dataSource = self
        bannerView.collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension BannerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getBannerImages().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
            fatalError("Unable to dequeue BannerCollectionViewCell")
        }
        let images = viewModel.getBannerImages()
        cell.configure(with: images[indexPath.item])
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
}
