//
//  TitleView.swift
//  Where_Are_You
//
//  Created by 오정석 on 22/7/2024.
//

import UIKit

class TitleView: UIView {
    // MARK: - Properties

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(Ttangsbudae: .bold, fontSize: 20))
        label.adjustsFontForContentSizeCategory = true
        label.text = "지금 어디?"
        label.textColor = .letterBrandColor
        return label
    }()
    
    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_bell_notification"), for: .normal)
        return button
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-mypage"), for: .normal)
        return button
    }()
    
    lazy var iconStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [notificationButton, profileButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
}
