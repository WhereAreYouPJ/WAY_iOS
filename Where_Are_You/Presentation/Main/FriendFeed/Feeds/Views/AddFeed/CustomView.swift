//
//  CustomView.swift
//  Where_Are_You
//
//  Created by 오정석 on 21/8/2024.
//

import UIKit

class CustomView: UIView {
    // MARK: - Properties

    private let separator1 = UIView()
    private let separator2 = UIView()
    let imageView = UIImageView()
    
    let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .black66, fontSize: 16)
    
    // MARK: - Lifecycle

    init(image: String, text: String, textColor: UIColor, separatorHidden: Bool, imageTintColor: UIColor) {
        super.init(frame: .zero)
        setupView(image: image, text: text, textColor: textColor, separatorHidden: separatorHidden)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupView(image: String, text: String, textColor: UIColor, separatorHidden: Bool) {
        imageView.image = UIImage(named: image)
        descriptionLabel.text = text
        descriptionLabel.textColor = textColor
        imageView.tintColor = .blackAC
        separator1.backgroundColor = .color221
        separator2.backgroundColor = .color221
        separator1.isHidden = separatorHidden
    }
    
    private func configureViewComponents() {
        addSubview(separator1)
        addSubview(separator2)
        addSubview(imageView)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        separator1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.leading.trailing.equalToSuperview()
        }
        
        separator2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.centerY.equalToSuperview()
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 30))
        }

        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing)
        }
    }
}
