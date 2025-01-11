//
//  ReasonSelectionTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/1/2025.
//

import UIKit
import SnapKit

class ReasonSelectionTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "ReasonSelectionTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.color221.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .color217
        return imageView
    }()
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.textColor = .color34
        return label
    }()

    
    // MARK: - Initializers
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
        contentView.addSubview(containerView)
        containerView.addSubview(checkmarkView)
        containerView.addSubview(reasonLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        

        checkmarkView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
        }
        
        reasonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkmarkView)
            make.leading.equalTo(checkmarkView.snp.trailing).offset(LayoutAdapter.shared.scale(value: 10))
        }
    }
    
    func configure(reason: String, isSelected: Bool) {
        reasonLabel.text = reason
        checkmarkView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        checkmarkView.tintColor = isSelected ? .brandColor : .color217
    }
}
