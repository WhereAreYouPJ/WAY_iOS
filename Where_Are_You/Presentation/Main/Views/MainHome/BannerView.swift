//
//  BannerView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import Foundation
import UIKit

class BannerView: UIView {
    
    // MARK: - Properties
    
    var collectionView: UICollectionView
    let pageControl = UIPageControl()
    var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        label.backgroundColor = UIColor.color68.withAlphaComponent(0.6)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(pageNumberLabel)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
        }
        
        pageNumberLabel.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().offset(-12)
            make.width.equalTo(42)
            make.height.equalTo(17)
        }
    }
}
