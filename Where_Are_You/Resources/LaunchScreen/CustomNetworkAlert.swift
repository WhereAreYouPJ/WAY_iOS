//
//  CustomNetworkAlert.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/7/2024.
//

import Foundation
import UIKit

class CustomNetworkAlert: UIView {
    
    // MARK: - Properties

    private let errorImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-network_alert")
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(32)
        }
        return imageView
    }()
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "인터넷 연결을 확인해주세요.", textColor: .color34, fontSize: 16)
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.color34, for: .normal)
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        button.layer.cornerRadius = 6
        button.layer.borderColor = UIColor.color118.cgColor
        button.backgroundColor = .white
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        button.layer.cornerRadius = 6
        button.backgroundColor = .brandColor
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [closeButton, actionButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    init(title: String, message: String, cancelTitle: String, actionTitle: String, action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true
        
        closeButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        
        addSubview(errorImage)
        addSubview(titleLabel)
        addSubview(buttonStack)
        
        setupConstraints()
        
        self.action = action
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private var action: (() -> Void)?
    
    private func setupConstraints() {
        
    }
    
    // MARK: - Selectors

    @objc private func dismissAlert() {
        self.removeFromSuperview()
    }
    
    @objc private func actionTapped() {
        self.action?()
        self.removeFromSuperview()
    }
    
    func showAlert(on viewController: UIViewController) {
        if let parentView = viewController.view {
            parentView.addSubview(self)
            self.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(parentView).multipliedBy(0.8)
                make.height.equalTo(parentView).multipliedBy(0.25)
            }
        }
    }
}
