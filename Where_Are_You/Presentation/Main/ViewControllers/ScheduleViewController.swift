//
//  ScheduleViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class ScheduleViewController: UIViewController {
    private let scheduleView = ScheduleView()
    private var viewModel: ScheduleViewModel!
    
    override func loadView() {
        view = scheduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ScheduleViewModel()
        setupBindings()
        setupCollectionView()
        viewModel.fetchSchedules()
    }
    
    private func setupBindings() {
        viewModel.onScheduleDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.scheduleView.collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView() {
        scheduleView.collectionView.dataSource = self
        scheduleView.collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getSchedules().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else {
            fatalError("Unable to dequeue ScheduleCell")
        }
        cell.configure(with: viewModel.getSchedules()[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
