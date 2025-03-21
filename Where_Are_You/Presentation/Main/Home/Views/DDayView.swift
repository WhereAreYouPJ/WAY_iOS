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
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.blackF0.cgColor
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupCollectionView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false // 스크롤 비활성화
        collectionView.register(DDAyCell.self, forCellWithReuseIdentifier: DDAyCell.identifier)
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(collectionView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(dDayExists: Bool) {
        containerView.layer.borderColor = dDayExists ? UIColor.brandMain.cgColor : UIColor.blackF0.cgColor
    }
}
