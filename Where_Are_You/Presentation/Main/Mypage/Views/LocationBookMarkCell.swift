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
    
    let selectButton: UIButton = {
        let button = UIButton()
        button.imageView?.image = UIImage(named: "icon-deselected")
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectButton.isHidden = true
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        locationLabel.textColor = .color34
        locationLabel.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 16))
        contentView.addSubview(locationLabel)
        contentView.addSubview(selectButton)
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 6))
            make.top.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 11))
        }
        
        selectButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 22))
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with location: FavLocation) {
        locationLabel.text = location.location
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            // 선택되었을때 상태
            selectButton.imageView?.image = UIImage(named: "icon-selected")
        } else {
            // 선택 안되었을때 상태
            selectButton.imageView?.image = UIImage(named: "icon-deselected")
        }
    }
}
