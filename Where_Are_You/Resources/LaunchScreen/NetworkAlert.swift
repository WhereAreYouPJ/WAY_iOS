//
//  CustomNetworkAlert.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/7/2024.
//

import UIKit
import SnapKit

class NetworkAlert: UIView {
    
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
    
    init(action: @escaping () -> Void) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.cornerRadius = 6
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
        errorImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(errorImage.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().offset(39.5)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().offset(14)
        }
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
                make.width.equalTo(280)
                make.height.equalTo(160)
            }
        }
    }
}
