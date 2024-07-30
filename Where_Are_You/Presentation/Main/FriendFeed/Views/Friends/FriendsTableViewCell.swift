//
//  FriendsTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit
import SnapKit

class FriendsTableViewCell: UITableViewCell {
    static let identifier = "FriendsTableViewCell"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color34, fontSize: 14)
    
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
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(6)
        }
    }
}
