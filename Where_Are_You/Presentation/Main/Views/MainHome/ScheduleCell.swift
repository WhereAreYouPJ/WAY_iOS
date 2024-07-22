//
//  ScheduleViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/7/2024.
//

import UIKit
import SnapKit

class ScheduleCell: UICollectionViewCell {
    // MARK: - Properties

    static let identifier = "ScheduleCell"
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .scheduleDateColor
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .color34
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        return label
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .color118
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        label.text = "일정이 없습니다."
        label.isHidden = true
        return label
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func setupViews() {
        addSubview(dDayLabel)
        addSubview(titleLabel)
        addSubview(emptyLabel)
        
        dDayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with schedule: Schedule?) {
        if let schedule = schedule {
            dDayLabel.isHidden = false
            titleLabel.isHidden = false
            emptyLabel.isHidden = true
            dDayLabel.text = "D - \(schedule.dDay)"
            titleLabel.text = schedule.title
        } else {
            dDayLabel.isHidden = true
            titleLabel.isHidden = true
            emptyLabel.isHidden = false
        }
    }
}
