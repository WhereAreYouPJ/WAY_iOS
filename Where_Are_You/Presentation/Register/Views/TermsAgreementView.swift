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
        view.backgroundColor = .color234
        return view
    }()
    
    private let colorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightpurple
        view.layer.cornerRadius = 3
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "회원가입에 필요한 약관에 동의해주세요", textColor: .color34, fontSize: 22)
    
    private let agreeView: UIView = {
        let view = UIView()
        let imageview = UIImageView()
        imageview.image = UIImage(named: "Rectangle137")
        view.addSubview(imageview)
        imageview.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()
    
    let agreeButton = CustomButton(title: "동의하고 시작하기", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
        }
        
        progressBar.addSubview(colorBar)
        colorBar.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.333)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(26)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(200)
        }
        
        addSubview(agreeView)
        agreeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(420)
        }
        
        agreeView.addSubview(agreeButton)
        agreeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(agreeButton.snp.width).multipliedBy(0.145)
            make.top.equalToSuperview().offset(192)
        }
        
    }
}
