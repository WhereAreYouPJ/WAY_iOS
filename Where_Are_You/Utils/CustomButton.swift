//
//  CustomButtonView.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/5/2024.
//

import UIKit
import SnapKit

// MARK: - CustomButton in SearchAccountOptionsView
class CustomButtonFindAccount: UIButton {
    
    private let arrowImageView = UIImageView()
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        
        setupView(title: title, description: description)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(title: String, description: String) {
        layer.borderColor = UIColor.color118.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 7
        backgroundColor = .white
        
        let titleLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: title, textColor: .color34, fontSize: 14)
        let descriptionLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: description, textColor: .color102, fontSize: 12)
        
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .color17
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(9)
            make.centerY.equalToSuperview()
            make.width.equalTo(272)
        }
        
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Box Button
class CustomButton: UIButton {

    init(title: String, backgroundColor: UIColor, titleColor: UIColor, font: UIFont, image: UIImage? = nil) {
        super.init(frame: .zero)
        setupButton(title: title, backgroundColor: backgroundColor, titleColor: titleColor, font: font, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String, backgroundColor: UIColor, titleColor: UIColor, font: UIFont, image: UIImage?) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        
        if let image = image {
            self.setImage(image, for: .normal)
            self.imageView?.contentMode = .scaleAspectFit
            self.contentHorizontalAlignment = .center
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        } else {
            self.contentHorizontalAlignment = .center
        }
    }
}

// MARK: - ONLY Label
class CustomButtonView: UIView {
    
    // MARK: - Properties
    let button: UIButton
    
    // MARK: - Lifecycle
    init(text: String, weight: UIFont.Weight, textColor: UIColor, fontSize: CGFloat) {
        self.button = UIButton(type: .system)
        super.init(frame: .zero)
        
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: weight, fontSize: fontSize)
        button.setTitleColor(textColor, for: .normal)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6))
        }
    }
}
