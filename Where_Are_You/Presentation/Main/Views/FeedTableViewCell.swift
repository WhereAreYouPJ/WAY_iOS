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
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color102, fontSize: 14)
    
    private let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color34, fontSize: 16)
    
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
            make.top.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview()
        }

        // 부제목 추가해야함
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }

        // 더보기 를 해결해야함
        moreLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }

        descriptionLabel.numberOfLines = 2
    }

    func configure(with feed: String) {
        titleLabel.text = "제목: \(feed)"
        descriptionLabel.text = "내용: \(feed)"
    }
}
