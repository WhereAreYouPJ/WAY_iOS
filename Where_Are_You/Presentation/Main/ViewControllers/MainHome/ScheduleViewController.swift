//
//  ScheduleViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class ScheduleViewController: UIViewController {
    // MARK: - Properties
    
    let scheduleView = ScheduleView()
    var viewModel: ScheduleViewModel!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = scheduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ScheduleViewModel()
        setupBindings()
        setupCollectionView()
        viewModel.fetchSchedules()
        
        // NotificationCenter를 통해 알림을 수신하는 옵저버를 추가합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToScheduleIndex(_:)), name: .scrollToScheduleIndex, object: nil)
    }
    
    // MARK: - Helpers
    
    private func setupBindings() {
        viewModel.onScheduleDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.scheduleView.collectionView.reloadData()
                self?.scrollToInitialPosition()
            }
        }
    }
    
    private func setupCollectionView() {
        scheduleView.collectionView.dataSource = self
        scheduleView.collectionView.delegate = self
    }
    
    private func scrollToInitialPosition() {
        if viewModel.getSchedules().isEmpty { return }
        let initialIndexPath = IndexPath(item: 1, section: 0) // Start at the first actual item
        scheduleView.collectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - Selectors
    
    // NotificationCenter로부터 알림을 수신하여 콜렉션 뷰를 업데이트합니다.
    @objc private func scrollToScheduleIndex(_ notification: Notification) {
        if let userInfo = notification.userInfo, let indexPath = userInfo["indexPath"] as? IndexPath {
            let correctedIndex = IndexPath(item: (indexPath.item + viewModel.getSchedules().count) % (viewModel.getSchedules().count + 2), section: 0)
            scheduleView.collectionView.scrollToItem(at: correctedIndex, at: .centeredHorizontally, animated: true)
        }
    }
    
    deinit {
        // 옵저버 제거
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UICollectionViewDataSource

extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(viewModel.getSchedules().count, 1) + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else {
            fatalError("Unable to dequeue ScheduleCell")
        }
        let schedules = viewModel.getSchedules()
        let correctedIndex = (indexPath.item + schedules.count) % (schedules.count + 2)
        if schedules.isEmpty {
            cell.configure(with: nil)
        } else {
            cell.configure(with: schedules[correctedIndex % schedules.count])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
