//
//  MainHomeViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import UIKit

class MainHomeViewController: UIViewController {
    private var mainHomeView: MainHomeView!
    private var viewModel: MainHomeViewModel!
    private var timer: Timer?
    
    override func loadView() {
        mainHomeView = MainHomeView(feeds: ["피드 1", "피드 2", "피드 3"])
        view = mainHomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainHomeViewModel()
        setupBindings()
        setupActions()
        setupBannerCollectionView()
        setupFeedTableView()
        viewModel.fetchBannerImages()
        viewModel.fetchSchedules()
        viewModel.fetchFeeds()
        startAutoScroll()
    }
    
    private func setupBindings() {
        viewModel.onBannerDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.mainHomeView.bannerView.pageControl.numberOfPages = self?.viewModel.getBannerImages().count ?? 0
                self?.mainHomeView.bannerView.collectionView.reloadData()
            }
        }
        
        viewModel.onScheduleDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.mainHomeView.scheduleView.schedules = self?.viewModel.getSchedules() ?? []
            }
        }
        
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.mainHomeView.feedTableView.feeds = self?.viewModel.getFeeds() ?? []
            }
        }
    }
    
    private func setupActions() {
        mainHomeView.reminderButton.addTarget(self, action: #selector(reminderButtonTapped), for: .touchUpInside)
    }
    
    private func setupBannerCollectionView() {
        mainHomeView.bannerView.collectionView.dataSource = self
        mainHomeView.bannerView.collectionView.delegate = self
    }
    
    private func setupFeedTableView() {
        mainHomeView.feedTableView.tableView.dataSource = self
        mainHomeView.feedTableView.tableView.delegate = self
    }
    
    // 이미지를 누르면 관련 이벤트로 넘어가는 로직
    func showEventDetail(for index: Int) {
        //        let eventDetailViewController = EventDetailViewController()
        //        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    // 추후 피드 메인 컨트롤러 만들어야 함
    @objc private func reminderButtonTapped() {
        //        let feedViewController = FeedViewController()
        //        navigationController?.pushViewController(feedViewController, animated: true)
    }
    
    @objc private func scrollToNextPage() {
        let visibleItems = mainHomeView.bannerView.collectionView.indexPathsForVisibleItems
        guard let currentItem = visibleItems.first else { return }
        let nextItem = IndexPath(item: (currentItem.item + 1) % viewModel.getBannerImages().count, section: 0)
        mainHomeView.bannerView.collectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
        mainHomeView.bannerView.pageControl.currentPage = nextItem.item
    }
}

// MARK: - UICollectionViewDataSource

extension MainHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getBannerImages().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as? BannerCollectionViewCell else {
            fatalError("Unable to dequeue FeedTableViewCell")
        }
        let images = viewModel.getBannerImages()
        cell.configure(with: images[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showEventDetail(for: indexPath.item)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getFeeds().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as? FeedTableViewCell else {
            fatalError("Unable to dequeue FeedTableViewCell")
        }
        cell.configure(with: viewModel.getFeeds()[indexPath.row])
        return cell
    }
}
