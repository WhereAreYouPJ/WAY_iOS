//
//  SignUpFormView.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/6/2024.
//

import UIKit
import SnapKit

class SignUpFormView: UIView {
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
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "아래 내용을 작성해주세요", textColor: .color34, fontSize: 22)
    
    let bottomContainerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.color221.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let bottomConfirmButton = CustomButton(title: "시작하기", backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
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
            make.width.equalToSuperview().multipliedBy(0.666)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar).offset(26)
            make.left.equalToSuperview().offset(20)
        }
        
        addSubview(bottomContainerView)
        bottomContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
        
        bottomContainerView.addSubview(bottomConfirmButton)
        bottomConfirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(bottomContainerView)
            make.top.equalTo(bottomContainerView.snp.top).offset(12)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(bottomConfirmButton.snp.width).multipliedBy(0.145)
        }
    }
    
}
