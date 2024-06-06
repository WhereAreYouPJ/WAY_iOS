//
//  FinishResetPasswordView.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit
import SnapKit

class FinishResetPasswordView: UIView {
    // MARK: - Properties
    
    let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "비밀번호 재설정이 완료되었습니다", textColor: .color34, fontSize: 22)
    
    let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: "시작화면에서 로그인해주세요.\n최초 로그인 이후 접속 시, 자동 로그인이 활성화됩니다.", textColor: .color102, fontSize: 14)
    
    let bottomButtonView = BottomButtonView(title: "확인")
    
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(38)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.477)
            make.height.equalTo(titleLabel.snp.width).multipliedBy(0.402)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.left.equalToSuperview().offset(15)
        }
        
        addSubview(bottomButtonView)
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
    }
}
