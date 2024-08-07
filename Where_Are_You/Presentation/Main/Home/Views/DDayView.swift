//
//  DDayView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class DDayView: UIView {
    // MARK: - Properties
    
    var collectionView: UICollectionView
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        let containerView = UIView()
        containerView.layer.borderColor = UIColor.color118.cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false // 스크롤 비활성화
        collectionView.register(DDAyCell.self, forCellWithReuseIdentifier: DDAyCell.identifier)
        
        addSubview(containerView)
        containerView.addSubview(collectionView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
