//
//  CustomAlert.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/7/2024.
//

import Foundation

import UIKit
import SnapKit

class CustomAlert: UIView {
    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .bold, fontSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.textColor = .color160
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.alertActionButtonColor, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, actionButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        return stackView
    }()
    
    // MARK: - Initializer
    
    init(title: String, message: String, cancelTitle: String, actionTitle: String, action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        backgroundColor = .color51.withAlphaComponent(0.8)
        layer.cornerRadius = 12
        clipsToBounds = true
        
        titleLabel.text = title
        messageLabel.text = message
        cancelButton.setTitle(cancelTitle, for: .normal)
        actionButton.setTitle(actionTitle, for: .normal)
        
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(labelStack)
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
        labelStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.176)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(28)
            make.trailing.equalToSuperview().inset(26)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
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
