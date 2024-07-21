//
//  ScheduleViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/7/2024.
//

import UIKit
import SnapKit

class ScheduleCell: UICollectionViewCell {
    static let identifier = "ScheduleCell"
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .scheduleDateColor
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .color34
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(dDayLabel)
        addSubview(titleLabel)
        
        dDayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with schedule: Schedule) {
        dDayLabel.text = "D - \(schedule.dDay)"
        titleLabel.text = schedule.title
    }
}
