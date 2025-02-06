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
    
    let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "비밀번호 재설정이 \n완료되었습니다.", textColor: .black22))
    
    let descriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "시작화면에서 로그인해주세요.\n최초 로그인 이후 접속 시, 자동 로그인이 활성화됩니다.", textColor: .black66))
    
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "로그인하기", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
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
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 54))
            make.leading.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 24))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 38))
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
