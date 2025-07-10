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
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
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
    
    func configure(with imageUrlString: String) {
        imageView.image = nil
        
        let imageUrl = URL(string: imageUrlString)
        imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "basic_profile_image"))
        imageView.isHidden = (imageUrl == nil)
    }
}
