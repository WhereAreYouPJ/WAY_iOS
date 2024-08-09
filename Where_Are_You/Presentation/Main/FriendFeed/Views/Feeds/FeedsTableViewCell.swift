//
//  FeedsTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "FeedsTableViewCell"
    
    let detailBox = FeedDetailBoxView()
    let feedImageView = FeedImageCollectionView()
    let bookMarkButton = UIButton()
    let descriptionLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func configureViewComponents() {
        contentView.addSubview(detailBox)
        contentView.addSubview(feedImageView)
        contentView.addSubview(bookMarkButton)
        contentView.addSubview(descriptionLabel)



    }
    
    private func setupConstraints() {
        
    }
}
