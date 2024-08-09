//
//  FeedImageCollectionView.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/8/2024.
//

import UIKit

class FeedImageCollectionView: UIView {
    // MARK: - Properties
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let pageControl = UIPageControl()
    
    var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = LayoutAdapter.shared.scale(value: 50)
        label.clipsToBounds = true
        label.textAlignment = .center
        label.textColor = .color223
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        label.backgroundColor = UIColor.color29.withAlphaComponent(0.4)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        layer.cornerRadius = LayoutAdapter.shared.scale(value: 16)
        clipsToBounds = true
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FeedImageCollectionViewCell.self, forCellWithReuseIdentifier: FeedImageCollectionViewCell.identifier)
        
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(pageNumberLabel)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview()
        }
        
        pageNumberLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-12)
            make.width.equalTo(42)
            make.height.equalTo(17)
        }
    }
}
