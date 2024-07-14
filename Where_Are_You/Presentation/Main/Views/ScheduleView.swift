//
//  ScheduleView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class ScheduleView: UIView {
    // MARK: - Properties
    
    private(set) var collectionView: UICollectionView!
    private var timer: Timer?
    private var currentIndex = 0
    
    var schedules: [String] = [] {
        didSet {
            currentIndex = 0
            collectionView.reloadData()
            startAutoScroll()
        }
    }
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let containerView = UIView()
        containerView.layer.borderColor = UIColor.color118.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.identifier)
        
        addSubview(containerView)
        containerView.addSubview(collectionView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextSchedule), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func scrollToNextSchedule() {
        guard schedules.count > 1 else { return }
        currentIndex = (currentIndex + 1) % schedules.count
        let nextIndexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    deinit {
        timer?.invalidate()
    }
}
