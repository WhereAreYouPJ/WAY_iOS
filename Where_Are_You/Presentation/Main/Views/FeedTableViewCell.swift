//
//  FeedTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class FeedTableViewCell: UITableViewCell {
    static let identifier = "FeedTableViewCell"
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let moreLabel: UILabel = {
        let label = UILabel()
        label.text = "더 보기"
        label.textColor = .blue
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(moreLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        moreLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = .darkGray
    }

    func configure(with feed: String) {
        titleLabel.text = "제목: \(feed)"
        descriptionLabel.text = "내용: \(feed)"
    }
}
