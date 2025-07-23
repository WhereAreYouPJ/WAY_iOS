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
        return imageView
    }()
    
    let imageEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-Camera_Rotate"), for: .normal)
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 12)
        return button
    }()
    
    let userNameLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP2(text: "유저 이름", textColor: .white))
    
    // 유저코드(친추용)
    let userCodeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 14)
        view.clipsToBounds = true
        return view
    }()
    
    let myCodeLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "내 코드", textColor: .black22))
    
    let userCodeLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "유저 코드", textColor: .brandDark))
    
    lazy var codeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [myCodeLabel, userCodeLabel])
        sv.spacing = LayoutAdapter.shared.scale(value: 8)
        sv.axis = .horizontal
        return sv
    }()
    
    // 내정보관리, 위치 즐겨찾기, 피드책갈피, 피드보관함
    private lazy var manageStackView: UIStackView = createStackView(buttonTitles: ["내 정보 관리", "위치 즐겨찾기", "피드 책갈피", "피드 보관함"], startingTag: 0)
    
    // 공지사항, 1:1이용문의
    private lazy var supportStackView: UIStackView = createStackView(buttonTitles: ["공지사항", "1:1 이용문의"], startingTag: 4)
    
    // 로그아웃, 회원탈퇴
    let logoutButton = StandardButton(text: UIFont.CustomFont.bodyP4(text: "로그아웃", textColor: .blackAC))
    
    let deleteAccountButton = StandardButton(text: UIFont.CustomFont.bodyP4(text: "회원탈퇴", textColor: .blackAC))
    
    private lazy var logoutDeleteStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoutButton, deleteAccountButton])
        stack.spacing = 20
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let separatorview: UIView = {
        let view = UIView()
        view.backgroundColor = .blackD4
        return view
    }()
    
    // 추가 옵션 뷰
    let moveToGallery = CustomOptionButtonView(title: "프로필 업로드", image: UIImage(named: "icon-Gallery"))
    
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
        backgroundColor = .blackF0
        
        addSubview(profileBackgroundView)
        profileBackgroundView.addSubview(profileImageView)
        profileBackgroundView.addSubview(userNameLabel)
        profileBackgroundView.addSubview(imageEditButton)
        profileBackgroundView.addSubview(moveToGallery)
        
        addSubview(userCodeBackgroundView)
        userCodeBackgroundView.addSubview(codeStackView)
//        userCodeBackgroundView.addSubview(myCodeLabel)
//        userCodeBackgroundView.addSubview(userCodeLabel)

        addSubview(manageStackView)
        addSubview(supportStackView)
        
        addSubview(logoutDeleteStackView)
        addSubview(separatorview)
    }
    
    private func setupConstraints() {
        // 유저프로필
        profileBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 270))
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(LayoutAdapter.shared.scale(value: 86))
            make.centerX.equalToSuperview()
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 88))
        }
        
        // 편집 버튼
        imageEditButton.snp.makeConstraints { make in
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 24))
            make.trailing.equalTo(profileImageView.snp.trailing).inset(LayoutAdapter.shared.scale(value: -2))
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        // 추가 옵션 뷰
        moveToGallery.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 11))
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        userCodeBackgroundView.snp.makeConstraints { make in
            make.centerY.equalTo(profileBackgroundView.snp.bottom)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 62))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        codeStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 내정보관리, 위치 즐겨찾기, 피드책갈피, 피드보관함
        manageStackView.snp.makeConstraints { make in
            make.top.equalTo(userCodeBackgroundView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 16))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 196))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        // 공지사항, 1:1이용문의
        supportStackView.snp.makeConstraints { make in
            make.top.equalTo(manageStackView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 104))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
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
        let label = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: title, textColor: .black22))
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 16))
        }
        return button
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .blackF0
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
        print("Configuring UI with member: \(member)")
        self.profileImageView.kf.setImage(with: URL(string: member.profileImage))
        self.userNameLabel.attributedText = UIFont.CustomFont.bodyP2(text: member.userName, textColor: .white)
        self.userCodeLabel.attributedText = UIFont.CustomFont.bodyP3(text: member.memberCode ?? "", textColor: .brandDark)
    }
}
