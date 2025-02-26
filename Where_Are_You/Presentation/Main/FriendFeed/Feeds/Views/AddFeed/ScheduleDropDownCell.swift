//
//  ScheduleDropDownCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/8/2024.
//

import UIKit

class ScheduleDropDownCell: UITableViewCell {
    
    static let identifier = "ScheduleDropDownCell"
    
    let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "t", textColor: .black22))
    
    let locationLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "l", textColor: .black66))
       
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewComponents() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(checkmarkImageView)
        
        checkmarkImageView.isHidden = true
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
            make.trailing.equalTo(checkmarkImageView.snp.leading).offset(LayoutAdapter.shared.scale(value: 6))
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(LayoutAdapter.shared.scale(value: 2))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8))
            make.leading.equalTo(titleLabel)
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 19))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 15.28))
        }
    }
    
    func configure(with schedule: ScheduleContent) {
        titleLabel.updateTextKeepingAttributes(newText: schedule.title)
        locationLabel.updateTextKeepingAttributes(newText: schedule.location)
        checkmarkImageView.isHidden = !schedule.feedExists
    }
}
