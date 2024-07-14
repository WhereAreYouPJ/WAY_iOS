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
    
    private let scheduleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        scheduleLabel.textAlignment = .center
        scheduleLabel.backgroundColor = .white
        scheduleLabel.textColor = .color34
        scheduleLabel.layer.borderColor = UIColor.color118.cgColor
        scheduleLabel.layer.borderWidth = 1
        scheduleLabel.layer.cornerRadius = 10
        scheduleLabel.clipsToBounds = true
        scheduleLabel.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        
        contentView.addSubview(scheduleLabel)
        scheduleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with schedule: String) {
        let attributedText = NSMutableAttributedString(string: schedule)
        attributedText.addAttribute(.foregroundColor, value: UIColor.red, range: (schedule as NSString).range(of: "D -"))
        scheduleLabel.attributedText = attributedText
    }
}
