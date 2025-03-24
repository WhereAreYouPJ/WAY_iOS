//
//  DDAyCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/7/2024.
//

import UIKit
import SnapKit

class DDAyCell: UICollectionViewCell {
    // MARK: - Properties

    static let identifier = "DDAyCell"
    
    private let dDayLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "dday", textColor: .error))
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "titlelabel", textColor: .black22))

    private let emptyLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "일정이 없습니다.", textColor: .black66))

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        emptyLabel.isHidden = true
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
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with dDay: DDay?) {
        if let dDay = dDay {
            dDayLabel.isHidden = false
            titleLabel.isHidden = false
            emptyLabel.isHidden = true
            if dDay.dDay == 0 {
                dDayLabel.updateTextKeepingAttributes(newText: "D - Day")
            } else {
                dDayLabel.updateTextKeepingAttributes(newText: "D - \(dDay.dDay)")
            }
            titleLabel.updateTextKeepingAttributes(newText: dDay.title)
        } else {
            dDayLabel.isHidden = true
            titleLabel.isHidden = true
            emptyLabel.isHidden = false
        }
    }
}
