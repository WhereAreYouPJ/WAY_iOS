//
//  FinishResetPasswordView.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit
import SnapKit

class PasswordFinishResetView: UIView {
    // MARK: - Properties
    
    let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "비밀번호 재설정이 완료되었습니다", textColor: .color34, fontSize: 22)
    
    let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: "시작화면에서 로그인해주세요.\n최초 로그인 이후 접속 시, 자동 로그인이 활성화됩니다.", textColor: .color102, fontSize: 14)
    
    let bottomButtonView = BottomButtonView(title: "로그인하기")
    
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
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(bottomButtonView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(38)
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.477)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.leading.equalToSuperview().inset(15)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
