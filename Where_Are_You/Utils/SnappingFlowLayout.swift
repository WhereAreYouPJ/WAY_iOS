//
//  SnappingFlowLayout.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/8/2024.
//

import UIKit

class SnappingFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            // 각 셀의 크기를 설정합니다. 여기서 collectionView.frame.width - 12는 양쪽 간격을 고려한 것입니다.
            itemSize = CGSize(width: collectionView.frame.width - 12, height: collectionView.frame.height)
            minimumLineSpacing = 6 // 셀 사이의 간격을 12로 설정
            minimumInteritemSpacing = 0
            sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6) // 섹션의 시작과 끝에 간격 추가
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + (collectionView.bounds.width / 2)
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
