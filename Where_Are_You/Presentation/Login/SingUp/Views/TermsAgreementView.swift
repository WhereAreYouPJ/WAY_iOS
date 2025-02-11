//
//  TermsAgreementView.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/6/2024.
//

import UIKit
import SnapKit

class TermsAgreementView: UIView {
    
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
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "회원가입에 필요한 \n약관에 동의해주세요", textColor: .black22))
    
    private let agreeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.04
        view.layer.shadowRadius = 6
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: -6, width: UIScreen.main.bounds.width, height: 192 + 6), cornerRadius: 24)
        view.layer.shadowPath = shadowPath.cgPath
        return view
    }()
    
    private let checkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon-checkBox")
        return iv
    }()
    
    private let agreeTitle = StandardLabel(UIFont: UIFont.CustomFont.bodyP2(text: "모두 동의하기", textColor: .black22))
    
    private lazy var termTitleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [checkImageView, agreeTitle])
        sv.axis = .horizontal
        sv.spacing = 0
        return sv
    }()
    
    private let termsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "동의하고 시작하기", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
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
        addSubview(bottomButtonView)
        addSubview(agreeView)
    }
    
    private func setupConstraints() {
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        colorBar.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.333)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(51)
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        agreeView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButtonView.snp.top).offset(LayoutAdapter.shared.scale(value: -12))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 192))
            make.leading.trailing.equalToSuperview()
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
