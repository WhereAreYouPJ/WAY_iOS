//
//  CustomAlert.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/7/2024.
//

import UIKit
import SnapKit
import SwiftUI

class CustomAlert: UIView {
    // MARK: - Properties
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.alpha = 0
        return view
    }()
    
    private var titleLabel = UILabel()
    
    private var messageLabel = UILabel()
    
    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private var cancelButton = UIButton()
    
    private var actionButton = UIButton()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, actionButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Initializer
    
    init(title: String, message: String, cancelTitle: String, actionTitle: String, action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        backgroundColor = .black44
        layer.cornerRadius = 12
        clipsToBounds = true
                
        titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH3(text: title, textColor: .white))
        
        messageLabel.lineBreakMode = .byCharWrapping

        messageLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: message, textColor: .blackD4))
        
        cancelButton = StandardButton(text: UIFont.CustomFont.bodyP4(text: cancelTitle, textColor: .white))
        actionButton = StandardButton(text: UIFont.CustomFont.bodyP4(text: actionTitle, textColor: .secondaryDark))
        
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        
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
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 26))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(LayoutAdapter.shared.scale(value: 11))
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 18))
        }
    }
    
    @objc private func dismissAlert() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.backgroundView.alpha = 0
                self.alpha = 0
            }, completion: { _ in
                self.backgroundView.removeFromSuperview()
                self.removeFromSuperview()
            })
    }
    
    @objc private func actionTapped() {
        self.action?()
        self.dismissAlert()
    }
    
    func showAlert(on viewController: UIViewController) {
        guard let window = viewController.view.window else { return }
        
        // 전체 화면을 덮는 배경 뷰 추가
        window.addSubview(backgroundView)
        backgroundView.frame = window.bounds
        
        // 알림 뷰 추가
        window.addSubview(self)
        self.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 240))
        }
        
        // 배경 뷰와 알림 뷰에 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.alpha = 1
        }
    }
}

extension CustomAlert {
    func update(isPresented: Binding<Bool>) {
        if !isPresented.wrappedValue {
            dismissAlert()
        }
    }
}
