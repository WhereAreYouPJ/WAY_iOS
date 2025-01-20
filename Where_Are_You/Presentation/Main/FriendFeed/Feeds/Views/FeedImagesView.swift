//
//  FeedImageCollectionView.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/8/2024.
//

import UIKit

class FeedImagesView: UIView {
    // MARK: - Properties
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        return collectionView
    }()
        
    var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = LayoutAdapter.shared.scale(value: 10)
        label.clipsToBounds = true
        label.textAlignment = .center
        label.textColor = .color223
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = UIColor.color29.withAlphaComponent(0.4)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureViewComponents() {        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
        addSubview(pageNumberLabel)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageNumberLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 44))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 23))
        }
    }
}
