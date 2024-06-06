//
//  CustomLabel.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/6/2024.
//

import UIKit
import SnapKit

// inputContainerLabel
class CustomLabel: UILabel {
    
    let label = UILabel()
    
    init(UILabel_NotoSans weight: UIFont.Weight, text: String, textColor: UIColor, fontSize: CGFloat) {
        super.init(frame: .zero)
        
        label.text = text
        label.textColor = textColor
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: weight, fontSize: fontSize))
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
