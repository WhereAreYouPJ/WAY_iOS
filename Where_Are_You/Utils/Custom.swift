//
//  CustomButtonView.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/5/2024.
//

import UIKit
import SnapKit

// MARK: - CustomButton

// MARK: - 자주 사용하는 하단의 inputcontainer 버튼 한개
class BottomButtonView: UIView {
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .color221
        return view
    }()
    
    var button: CustomButton
    
    init(title: String) {
        self.button = CustomButton(title: title, backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
        super.init(frame: .zero)
        setupView(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(title: String) {
        addSubview(border)
        border.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(border.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(self.snp.width).multipliedBy(0.145)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}

// MARK: - CustomButton in SearchAccountOptionsView
class CustomButtonFindAccount: UIButton {
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .color17
        return imageView
    }()
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        setupView(title: title, description: description)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String, description: String) {
        layer.borderColor = UIColor.color118.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 7
        backgroundColor = .white
        
        let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: title, textColor: .color34, fontSize: 14)
        let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: description, textColor: .color102, fontSize: descriptionFontSize)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false
        
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
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = titleColor
        configuration.image = image
        configuration.imagePadding = 8
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        configuration.cornerStyle = .medium
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = font
        attributedTitle.foregroundColor = titleColor
        configuration.attributedTitle = attributedTitle
        
        self.configuration = configuration
        self.clipsToBounds = true
    }
}

// MARK: - Button ONLY Label
class CustomButtonView: UIView {
    
    let button: UIButton
    
    init(text: String, weight: UIFont.Weight, textColor: UIColor, fontSize: CGFloat) {
        self.button = UIButton(type: .system)
        super.init(frame: .zero)
        
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: weight, fontSize: fontSize))
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
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

// MARK: - CustomLabel

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

// MARK: - CustomTextField

class CustomTextField: UITextField {
    
    private var textPadding: UIEdgeInsets
    
    init(textPadding: UIEdgeInsets = UIEdgeInsets(top: 11, left: 8, bottom: 11, right: 8)) {
        self.textPadding = textPadding
        super.init(frame: .zero)
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        self.textPadding = UIEdgeInsets(top: 11, left: 8, bottom: 11, right: 8)
        super.init(coder: coder)
        setupBorder()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    private func setupBorder() {
        layer.borderColor = UIColor.color212.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 7.0
    }
    
    func setBorderColor(_ color: UIColor) {
        layer.borderColor = color.cgColor
    }
}
