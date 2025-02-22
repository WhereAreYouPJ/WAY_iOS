//
//  CommonAccountBoxView.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/1/2025.
//

import UIKit

class CommonAccountBoxView: UIView {
    // MARK: - Properties
    
    private let infoTitleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "", textColor: .black22))
    
    private let infoDescriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .black66))
    
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
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.blackD4.cgColor
        addSubview(infoTitleLabel)
        addSubview(infoDescriptionLabel)
    }
    
    private func setupConstraints() {
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 18))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
        }
        
        infoDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 8))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 18))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
        }
    }
    
    func configureUI(title: String, description: String) {
        infoTitleLabel.attributedText = UIFont.CustomFont.bodyP3(text: title, textColor: .black22)
        infoDescriptionLabel.attributedText = UIFont.CustomFont.bodyP5(text: description, textColor: .black66)
    }
    
    func configureUI(title: String, attributedDescription: NSAttributedString) {
        infoTitleLabel.attributedText = UIFont.CustomFont.bodyP3(text: title, textColor: .black22)
        infoDescriptionLabel.attributedText = attributedDescription
    }
}
