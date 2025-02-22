//
//  LocationBookMarkCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/9/2024.
//

import UIKit

class LocationBookMarkCell: UITableViewCell {
    static let identifier = "LocationBookMarkCell"
    
    let locationLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "", textColor: .black22))
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-deselected")
        imageView.isHidden = true
        return imageView
    }()
    
    var isChecked: Bool = false {
        didSet {
            updateCheckmark() // 상태 변경 시 바로 체크 표시 업데이트
        }
    }
    
    var selectionAction: (() -> Void)? // 선택 액션 클로저
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.addSubview(locationLabel)
        contentView.addSubview(checkmarkImageView)
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.centerY.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 24))
            make.centerY.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(with location: GetFavLocation, isSelected: Bool, isEditingMode: Bool) {
        locationLabel.attributedText = UIFont.CustomFont.bodyP3(text: location.location, textColor: .black22)
        checkmarkImageView.isHidden = !isEditingMode // 선택 가능하므로 보여주기
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
