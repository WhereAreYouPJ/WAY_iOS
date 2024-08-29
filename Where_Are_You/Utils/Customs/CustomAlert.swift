//
//  CustomAlert.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/7/2024.
//

import UIKit
import SnapKit

class CustomAlert: UIView {
    // MARK: - Properties
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .color5.withAlphaComponent(0.3)
        view.alpha = 0
        return view
    }()
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "", textColor: .white, fontSize: LayoutAdapter.shared.scale(value: 18))
    
    private let messageLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color160, fontSize: LayoutAdapter.shared.scale(value: 14))
    
    private lazy var labelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.alertActionButtonColor, for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, actionButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = LayoutAdapter.shared.scale(value: 24)
        return stackView
    }()
    
    // MARK: - Initializer
    
    init(title: String, message: String, cancelTitle: String, actionTitle: String, action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        backgroundColor = .color51
        layer.cornerRadius = LayoutAdapter.shared.scale(value: 12)
        clipsToBounds = true
        
        titleLabel.text = title
        messageLabel.text = message
        cancelButton.setTitle(cancelTitle, for: .normal)
        actionButton.setTitle(actionTitle, for: .normal)
        
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
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 20))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(LayoutAdapter.shared.scale(value: 28))
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 26))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
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
        print("확인 버튼 눌림")
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
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 16))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 210))
        }
        
        // 배경 뷰와 알림 뷰에 애니메이션 적용
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 1
            self.alpha = 1
        }
    }
}
