//
//  FinishRegisterview.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit
import SnapKit

class FinishRegisterview: UIView {
    // MARK: - Properties
    
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightpurple
        return view
    }()
    
    let titleLabel = CustomLabel(UILabel_NotoSans: .bold, text: "회원가입이 \n완료되었습니다", textColor: .black22, fontSize: 22)
    
    let descriptionLabel = CustomLabel(UILabel_NotoSans: .medium, text: "시작화면에서 로그인해주세요.\n최초 로그인 이후 접속 시, 자동 로그인이 활성화됩니다.", textColor: .black66, fontSize: 14)
    
    let bottomButtonView = BottomButtonView(title: "로그인하기")
    
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
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar).offset(30)
            make.leading.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.477)
            make.height.equalTo(titleLabel.snp.width).multipliedBy(0.402)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.leading.equalTo(titleLabel)
        }
        
        addSubview(bottomButtonView)
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()    
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
