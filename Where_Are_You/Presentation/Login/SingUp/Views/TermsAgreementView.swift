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
        view.backgroundColor = .color235
        return view
    }()
    
    private let colorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightpurple
        view.layer.cornerRadius = 3
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "회원가입에 필요한\n약관에 동의해주세요", textColor: .color34, fontSize: 22)
    
    // TODO: 추후에 agreeView를 이미지 말고 실제로 만들어야함
    private let agreeView: UIView = {
        let view = UIView()
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Rectangle137")
        view.addSubview(imageview)
        imageview.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.bottom.equalToSuperview()
        }
        return view
    }()
    
    let bottomButtonView = BottomButtonView(title: "동의하고 시작하기")
    
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
        addSubview(agreeView)
        agreeView.addSubview(bottomButtonView)
    }
    
    private func setupConstraints() {
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
        }
        
        colorBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.333)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(26)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(200)
        }
        
        agreeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(agreeView.snp.bottom)
        }
    }
}
