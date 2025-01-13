//
//  DDayViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class DDayViewController: UIViewController {
    // MARK: - Properties
    let dDayView = DDayView()
    var viewModel: DDayViewModel
    
    // MARK: - Initializer
    init(viewModel: DDayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = dDayView
        setupBindings()
        setupCollectionView()
        
        viewModel.fetchDDays()
        
        // NotificationCenter를 통해 알림을 수신하는 옵저버를 추가합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToDDayIndex(_:)), name: .scrollToDDayIndex, object: nil)
    }
    
    // MARK: - Helpers
    
    private func setupBindings() {
        viewModel.onDDayDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.dDayView.collectionView.reloadData()
                self?.scrollToInitialPosition()
            }
        }
    }
    
    private func setupCollectionView() {
        dDayView.collectionView.dataSource = self
        dDayView.collectionView.delegate = self
    }
    
    private func scrollToInitialPosition() {
        if viewModel.getDDays().isEmpty { return }
        let initialIndexPath = IndexPath(item: 1, section: 0) // Start at the first actual item
        dDayView.collectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - Selectors
    // NotificationCenter로부터 알림을 수신하여 콜렉션 뷰를 업데이트합니다.
    @objc private func scrollToDDayIndex(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let indexPath = userInfo["indexPath"] as? IndexPath {
            let correctedIndex = IndexPath(
                item: (indexPath.item + viewModel.getDDays().count) % (viewModel.getDDays().count + 2),
                section: 0
            )
            dDayView.collectionView.scrollToItem(
                at: correctedIndex,
                at: .centeredHorizontally,
                animated: true
            )
        }
    }
    
    deinit {
        // 옵저버 제거
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UICollectionViewDataSource

extension DDayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(viewModel.getDDays().count, 1) + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DDAyCell.identifier, for: indexPath) as? DDAyCell else { fatalError("Unable to dequeue DDayCell") }
        let dDays = viewModel.getDDays()
        let correctedIndex = (indexPath.item + dDays.count) % (dDays.count + 2)
        let dDayExists = !dDays.isEmpty
        dDayView.configureUI(dDayExists: dDayExists)
        if !dDayExists {
            cell.configure(with: nil)
        } else {
            cell.configure(with: dDays[correctedIndex % dDays.count])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DDayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
