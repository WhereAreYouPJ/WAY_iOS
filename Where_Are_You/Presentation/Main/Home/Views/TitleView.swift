//
//  TitleView.swift
//  Where_Are_You
//
//  Created by 오정석 on 22/7/2024.
//

import UIKit

class TitleView: UIView {
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
        button.setImage(UIImage(named: "icon-mypage"), for: .normal)
        return button
    }()
    
    private let iconStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        addSubview(titleLabel)
        addSubview(iconStack)
        iconStack.addArrangedSubview(notificationButton)
        iconStack.addArrangedSubview(profileButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.equalToSuperview().inset(18)
            make.height.equalTo(titleLabel.snp.width).multipliedBy(0.25)
        }
        
        iconStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(11)
        }
    }
}
