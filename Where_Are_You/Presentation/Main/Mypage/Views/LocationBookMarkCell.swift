//
//  LocationBookMarkCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/9/2024.
//

import UIKit

class LocationBookMarkCell: UITableViewCell {
    static let identifier = "LocationBookMarkCell"
    
    let locationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        locationLabel.textColor = .color34
        locationLabel.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 16))
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 6))
            make.top.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 11))
        }
    }
    
    func configure(with location: FavLocation) {
        locationLabel.text = location.location
    }
}
