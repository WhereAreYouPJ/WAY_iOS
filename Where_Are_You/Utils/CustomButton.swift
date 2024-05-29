//
//  CustomButtonView.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/5/2024.
//

import UIKit
import SnapKit

// MARK: - CustomButton

class CustomButton: UIButton {
    
    // MARK: - Lifecycle
    
    init(title: String, backgroundColor: UIColor, titleColor: UIColor, font: UIFont, image: UIImage? = nil) {
        super.init(frame: .zero)
        setupButton(title: title, backgroundColor: backgroundColor, titleColor: titleColor, font: font, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
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

// MARK: - CustomButton inside View

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
