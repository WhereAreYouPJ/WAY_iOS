//
//  SocialSignUpView.swift
//  Where_Are_You
//
//  Created by 오정석 on 20/1/2025.
//

import UIKit

class SocialSignUpView: UIView {
    // MARK: - Properties
    
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .blackF0
        return view
    }()
    
    private let colorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .brandMain
        view.layer.cornerRadius = 3
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "아래 내용을 작성해주세요", textColor: .black22))
    
    private let userNameLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: " 이름", textColor: .black22))
    
    let userNameTextField = CustomTextField(placeholder: "이름")
    
    let userNameErrorLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "", textColor: .brandMain))
    
    private lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [userNameLabel, userNameTextField, userNameErrorLabel])
        sv.spacing = 4
        sv.axis = .vertical
        return sv
    }()
    
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "시작하기", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewComponents() {
        addSubview(progressBar)
        progressBar.addSubview(colorBar)
        addSubview(titleLabel)
        addSubview(stack)
        addSubview(bottomButtonView)
    }
    
    private func setupConstraints() {
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        colorBar.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 51))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 40))
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
        }
    }
}
