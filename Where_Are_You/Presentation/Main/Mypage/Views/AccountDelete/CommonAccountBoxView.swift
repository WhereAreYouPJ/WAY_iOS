//
//  CommonAccountBoxView.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/1/2025.
//

import UIKit

class CommonAccountBoxView: UIView {
    // MARK: - Properties
    
    private let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let infoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 12)
        label.textColor = .color118
        label.numberOfLines = 0
        return label
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
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.color221.cgColor
        addSubview(infoTitleLabel)
        addSubview(infoDescriptionLabel)
    }
    
    private func setupConstraints() {
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 16))
        }
        
        infoDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 7))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 22))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 16))
        }
    }
    
    func configureUI(title: String, description: String) {
        infoTitleLabel.text = title
        infoDescriptionLabel.text = description
    }
    
    func configureUI(title: String, attributedDescription: NSAttributedString) {
        infoTitleLabel.text = title
        infoDescriptionLabel.attributedText = attributedDescription
    }
}
