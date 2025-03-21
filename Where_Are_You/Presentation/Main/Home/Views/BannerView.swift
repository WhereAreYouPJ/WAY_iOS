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
        
    let pageView: UIView = {
        let view = UIView()
        view.backgroundColor = .black44.withAlphaComponent(0.4)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var pageNumberLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "p", textColor: .white))
    
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
        layer.borderColor = UIColor.blackF0.cgColor
        backgroundColor = .white
        clipsToBounds = true
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        
        addSubview(collectionView)
        addSubview(pageView)
        pageView.addSubview(pageNumberLabel)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 37))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 20))
        }
        
        pageNumberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
