//
//  MypageView.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/7/2024.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    // MARK: - Properties
    
    private let profileBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandColor
        view.layer.cornerRadius = 18
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 34.44
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "exampleProfileImage")
        return imageView
    }()
    
    let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "유저 이름", textColor: .white, fontSize: 20)
    
    let userCodeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        return view
    }()
    
    // 유저코드(친추용)
    let userCodeLabel = CustomLabel(UILabel_NotoSans: .medium, text: "qwer0865", textColor: .letterBrandColor, fontSize: 14)
    
    // 내정보관리, 위치 즐겨찾기, 피드책갈피, 피드보관함
    private lazy var manageStackView: UIStackView = createStackView(buttonTitles: ["내 정보 관리", "위치 즐겨찾기", "피드 책갈피", "피드 보관함"])
    
    private lazy var supportStackView: UIStackView = createStackView(buttonTitles: ["공지사항", "1:1 이용문의"])
    
    // 공지사항, 1:1이용문의
    
    // 로그아웃, 회원탈퇴
    let logoutButton = CustomButtonView(text: "로그아웃", weight: .medium, textColor: .color190, fontSize: 14)
    
    let deleteAccountButton = CustomButtonView(text: "회원탈퇴", weight: .medium, textColor: .color190, fontSize: 14)
    
    private lazy var logoutDeleteStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoutButton, deleteAccountButton])
        stack.spacing = 4
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let separatorview: UIView = {
        let view = UIView()
        view.backgroundColor = .color190
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureViewComponents() {
        backgroundColor = .color240
        
        addSubview(profileBackgroundView)
        profileBackgroundView.addSubview(profileImageView)
        profileBackgroundView.addSubview(userNameLabel)
        
        addSubview(userCodeBackgroundView)
        userCodeBackgroundView.addSubview(userCodeLabel)
        
        addSubview(manageStackView)
        addSubview(supportStackView)
        
        addSubview(logoutDeleteStackView)
        addSubview(separatorview)
    }
    
    func setupConstraints() {
        // 유저프로필
        profileBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(0.747)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileBackgroundView.snp.top).inset(90)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(self.snp.width).multipliedBy(0.266)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        // 유저코드
        userCodeBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(profileBackgroundView.snp.bottom)
            make.height.equalTo(profileBackgroundView.snp.height).multipliedBy(0.203)
            make.leading.trailing.equalToSuperview().inset(6)
        }
        
        userCodeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 내정보관리, 위치 즐겨찾기, 피드책갈피, 피드보관함
        manageStackView.snp.makeConstraints { make in
            make.top.equalTo(userCodeBackgroundView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        // 공지사항, 1:1이용문의
        supportStackView.snp.makeConstraints { make in
            make.top.equalTo(manageStackView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(17)
        }
        
        // 로그아웃, 회원탈퇴 버튼
        logoutDeleteStackView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(120)
            make.height.equalTo(logoutDeleteStackView.snp.width).multipliedBy(0.206)
        }
        
        separatorview.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(14)
            make.centerY.equalTo(logoutDeleteStackView)
            make.centerX.equalToSuperview()
        }
    }
    
    private func createStackView(buttonTitles: [String]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.layer.cornerRadius = 14
        stackView.clipsToBounds = true
        stackView.backgroundColor = .white
        
        buttonTitles.forEach { title in
            let button = createButton(withTitle: title)
            stackView.addArrangedSubview(button)
            
            if title != buttonTitles.last {
                let separator = createSeparator()
                stackView.addArrangedSubview(separator)
            }
        }
        return stackView
    }
    
    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        let label = CustomLabel(UILabel_NotoSans: .medium, text: title, textColor: .color34, fontSize: 16)
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        button.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        return button
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return separator
    }
    
    func setButtonActions(target: Any?, action: Selector) {
        manageStackView.arrangedSubviews.forEach {
            if let button = $0 as? UIButton {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
        }
        
        supportStackView.arrangedSubviews.forEach {
            if let button = $0 as? UIButton {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
        }
    }
}
