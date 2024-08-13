//
//  FeedImageCollectionViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/8/2024.
//

import UIKit

class FeedImageCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    static let identifier = "FeedImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    func configure(with image: UIImage) {
        if image == nil {
            imageView.isHidden = true
        } else {
            imageView.isHidden = false
            imageView.image = image
        }
    }
}
