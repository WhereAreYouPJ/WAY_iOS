//
//  HomeFeedView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class HomeFeedView: UIView {
    
    // MARK: - Properties
    
    var collectionView: UICollectionView = {
        let layout = SnappingFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast
        return cv
    }()
    
    let noFeedLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 하루 수고했던 일은 \n어떤 경험을 남기게 했나요? \n\n하루의 소중한 시간을 기록하고 \n오래 기억될 수 있도록 간직해보세요!"
        label.textColor = .color153
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center        
        label.layer.borderColor = UIColor.color221.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = LayoutAdapter.shared.scale(value: 15)
        label.clipsToBounds = true
        return label
    }()
    
    var feeds: [Feed] = [] {
        didSet {
            updateFeeds()
        }
    }
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func setupViews() {
        addSubview(collectionView)
        backgroundColor = .blackF8
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateFeeds() {
        if feeds.isEmpty {
            addSubview(noFeedLabel)
            noFeedLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
                make.height.equalTo(LayoutAdapter.shared.scale(value: 160))
                make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            }
            collectionView.isHidden = true
        } else {
            noFeedLabel.removeFromSuperview()
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
}
