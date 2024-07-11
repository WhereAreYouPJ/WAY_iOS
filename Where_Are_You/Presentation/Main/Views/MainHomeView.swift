//
//  MainHomeView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import Foundation
import UIKit

class MainHomeView: UIView {
    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(Ttangsbudae: .bold, fontSize: 20))
        label.adjustsFontForContentSizeCategory = true
        label.text = "지금 어디?"
        label.textColor = .letterBrandColor
        return label
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_bell_notification"), for: .normal)
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_profile"), for: .normal)
        return button
    }()
    
    // 배너 슬라이드 이미지
    
    // 자동 슬라이드 일정
    
    private let reminderLabel = CustomLabel(UILabel_NotoSans: .medium, text: "함께한 추억을 확인해보세요!", textColor: .color34, fontSize: 20) // 새로 커스텀 버튼을 만들어서 추가하기
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
    }
    
}
