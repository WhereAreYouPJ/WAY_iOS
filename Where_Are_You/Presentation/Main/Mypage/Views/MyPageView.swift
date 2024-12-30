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
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 18)
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 34.44)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "exampleProfileImage")
        return imageView
    }()
    
    let imageEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-Camera_Rotate"), for: .normal)
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 10)
        return button
    }()
    
    let userNameLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .white, fontSize: 20)
    
    // 유저코드(친추용)
    let userCodeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        view.clipsToBounds = true
        return view
    }()
    
    let userCodeLabel = CustomLabel(UILabel_NotoSans: .medium, text: "qwer0865", textColor: .letterBrandColor, fontSize: 14)
    
    // 내정보관리, 위치 즐겨찾기, 피드책갈피, 피드보관함
    private lazy var manageStackView: UIStackView = createStackView(buttonTitles: ["내 정보 관리", "위치 즐겨찾기", "피드 책갈피", "피드 보관함"], startingTag: 0)
    
    // 공지사항, 1:1이용문의
    private lazy var supportStackView: UIStackView = createStackView(buttonTitles: ["공지사항", "1:1 이용문의"], startingTag: 4)
    
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
    
    // 추가 옵션 뷰
    let moveToGallery = CustomOptionButtonView(title: "사진 보관함", image: UIImage(named: "icon-Gallery"))
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        moveToGallery.isHidden = true
        moveToGallery.isUserInteractionEnabled = true
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
        profileBackgroundView.addSubview(imageEditButton)
        profileBackgroundView.addSubview(moveToGallery)
        
        addSubview(userCodeBackgroundView)
        userCodeBackgroundView.addSubview(userCodeLabel)
        
        addSubview(manageStackView)
        addSubview(supportStackView)
        
        addSubview(logoutDeleteStackView)
        addSubview(separatorview)
    }
    
    private func setupConstraints() {
        // 유저프로필
        profileBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 280))
        }
        
        profileImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 100))
        }
        
        // 편집 버튼
        imageEditButton.snp.makeConstraints { make in
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 24))
            make.trailing.equalTo(profileImageView.snp.trailing).offset(LayoutAdapter.shared.scale(value: 6))
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        // 추가 옵션 뷰
        moveToGallery.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 13))
            make.width.equalTo(190)
            make.height.equalTo(38)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        userCodeBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(profileBackgroundView.snp.bottom)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 57))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 17))
        }
        
        userCodeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 내정보관리, 위치 즐겨찾기, 피드책갈피, 피드보관함
        manageStackView.snp.makeConstraints { make in
            make.top.equalTo(userCodeBackgroundView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 14))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 192))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 17))
        }
        
        // 공지사항, 1:1이용문의
        supportStackView.snp.makeConstraints { make in
            make.top.equalTo(manageStackView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 102))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 17))
        }
        
        // 로그아웃, 회원탈퇴 버튼
        logoutDeleteStackView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 20))
            make.centerX.equalToSuperview()
        }
        
        separatorview.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(14)
            make.centerY.equalTo(logoutDeleteStackView)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - stackview func
    
    private func createStackView(buttonTitles: [String], startingTag: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        stackView.clipsToBounds = true
        stackView.backgroundColor = .white
        stackView.distribution = .fillProportionally
        
        var buttonTag = startingTag
        
        for title in buttonTitles {
            let button = createButton(withTitle: title)
            button.tag = buttonTag  // 버튼에 고유한 tag 값 할당
            buttonTag += 1
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
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
        }
        return button
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .color221
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return separator
    }
    
    // MARK: - stackview button actions
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
    
    func configureUI(member: Member) {
        self.profileImageView.kf.setImage(with: URL(string: member.profileImage))
        self.userNameLabel.text = member.userName
        self.userCodeLabel.text = member.memberCode
    }
}
