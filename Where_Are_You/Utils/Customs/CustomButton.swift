//
//  CustomButtonView.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/5/2024.
//

import UIKit
import SnapKit
import Foundation

// MARK: - 추가 옵션뷰 버튼
class CustomOptionButtonView: UIView {
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .popupButtonColor
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 10)
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Initializer
    init(title: String, image: UIImage? = nil) {
        super.init(frame: .zero)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        createButton(title: title, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func createButton(title: String, image: UIImage? = nil) -> UIButton {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: LayoutAdapter.shared.scale(value: 14), weight: .medium)
        label.adjustsFontForContentSizeCategory = true
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
        }
        
        if let image = image {
            let imageView = UIImageView()
            imageView.image = image
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(LayoutAdapter.shared.scale(value: 22))
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 13))
            }
        }
        return button
    }
}

// MARK: - 자주 사용하는 하단의 inputcontainer 버튼 한개
class BottomButtonView: UIView {
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .color221
        return view
    }()
    
    var button: CustomButton
    
    init(title: String) {
        self.button = CustomButton(title: title, backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: LayoutAdapter.shared.scale(value: 18)))
        super.init(frame: .zero)
        backgroundColor = .white
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
            make.leading.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(border.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
            make.leading.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 15))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
    }
}

// MARK: - Box Button
class CustomButton: UIButton {
    
    // MARK: - Properties
    private var buttonTitle: String
    private var buttonBackgroundColor: UIColor
    private var buttonTitleColor: UIColor
    private var buttonFont: UIFont
    
    // MARK: - Initializer
    init(title: String, backgroundColor: UIColor, titleColor: UIColor, font: UIFont) {
        self.buttonTitle = title
        self.buttonBackgroundColor = backgroundColor
        self.buttonTitleColor = titleColor
        self.buttonFont = font
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Button
    private func setupButton() {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(buttonTitleColor, for: .normal)
        backgroundColor = buttonBackgroundColor
        titleLabel?.font = buttonFont
        
        // 중앙 정렬
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        
        // 버튼 모서리 둥글게
        layer.cornerRadius = LayoutAdapter.shared.scale(value: 6)
        clipsToBounds = true
    }
    
    // MARK: - Public Methods
    func updateTitle(_ title: String) {
        self.buttonTitle = title
        setTitle(buttonTitle, for: .normal)
    }
    
    func updateBackgroundColor(_ color: UIColor) {
        self.buttonBackgroundColor = color
        backgroundColor = color
    }
    
    func updateTitleColor(_ color: UIColor) {
        self.buttonTitleColor = color
        setTitleColor(buttonTitleColor, for: .normal)
    }
    
    func updateFont(_ font: UIFont) {
        self.buttonFont = font
        titleLabel?.font = font
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
