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
    
    var button = UIButton()
    
    init(title: String) {
        super.init(frame: .zero)
        setupView(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(title: String) {
        self.layer.borderColor = UIColor.color221.cgColor
        self.layer.borderWidth = 1
        self.snp.makeConstraints { make in
            make.height.equalTo(220)
        }
        
        button = CustomButton(title: title, backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(self.snp.width).multipliedBy(0.145)
        }
    }
}

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
        
        let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: title, textColor: .color34, fontSize: 14)
        
        let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: description, textColor: .color102, fontSize: descriptionFontSize)
        
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
        self.titleLabel?.font = UIFontMetrics.default.scaledFont(for: font)
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        self.titleLabel?.adjustsFontForContentSizeCategory = true
        
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
    
    var textPadding = UIEdgeInsets(top: 11, left: 8, bottom: 11, right: 8)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBorder()
    }
    
    private func setupBorder() {
        layer.borderColor = UIColor.color212.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 7.0
    }
}
