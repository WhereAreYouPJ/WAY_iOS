//
//  FeedImageCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 13/11/2024.
//

import UIKit

protocol FeedImageCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: FeedImageCell)
}

class FeedImageCell: UICollectionViewCell {
    static let identifier = "FeedImageCell"
    
    weak var delegate: FeedImageCellDelegate?
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = LayoutAdapter.shared.scale(value: 4.8)
        return iv
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 22))
        }
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    @objc private func deleteTapped() {
        // 이미지 삭제 로직
        delegate?.didTapDeleteButton(in: self)
    }
}
