//
//  FeedView.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/11/2024.
//

import UIKit

class FeedView: UIView {
    let scheduleInfoView = FeedDetailBoxView()
    
    let feedImageCollectionView: UICollectionView = {
        let layout = SnappingFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-feed_bookmark"), for: .normal)
        button.setImage(UIImage(named: "icon-feed_bookmark_filled"), for: .selected)
        return button
    }()
    
    let feedInfoContentView = UIView()
}
