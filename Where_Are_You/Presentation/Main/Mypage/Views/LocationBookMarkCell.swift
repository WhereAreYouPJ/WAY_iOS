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
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-deselected")
        imageView.isHidden = true
        return imageView
    }()
    
    var isChecked: Bool = false // 선택 상태를 관리하는 변수
    var selectionAction: (() -> Void)? // 선택 액션 클로저
    
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
        contentView.addSubview(checkmarkImageView)
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 6))
            make.centerY.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 22))
            make.centerY.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(with location: FavLocation, isSelected: Bool) {
        locationLabel.text = location.location
        checkmarkImageView.isHidden = false // 선택 가능하므로 보여주기
        self.isChecked = isSelected
        updateCheckmark()
    }
    
    private func updateCheckmark() {
        checkmarkImageView.image = isChecked ? UIImage(named: "icon-selected") : UIImage(named: "icon-deselected")
    }
    
    @objc func handleTap() {
        isChecked.toggle()
        updateCheckmark()
        selectionAction?()
    }
}
