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
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
        
    var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        label.backgroundColor = UIColor.color68.withAlphaComponent(0.6)
        label.layer.cornerRadius = LayoutAdapter.shared.scale(value: 10)
        label.clipsToBounds = true
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
        layer.cornerRadius = 16
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.color221.cgColor
        backgroundColor = .white
        clipsToBounds = true
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        
        addSubview(collectionView)
        addSubview(pageNumberLabel)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageNumberLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-12)
            make.width.equalTo(LayoutAdapter.shared.scale(value: 42))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 17))
        }
    }
}
