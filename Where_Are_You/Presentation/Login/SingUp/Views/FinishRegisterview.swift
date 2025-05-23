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
        view.backgroundColor = .brandMain
        return view
    }()
    
    let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "회원가입이 \n완료되었습니다", textColor: .black22))
    
    let descriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "시작화면에서 로그인해주세요.\n최초 로그인 이후 접속 시, 자동 로그인이 활성화됩니다.", textColor: .black66))
        
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "시작하기", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
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
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(bottomButtonView)

        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar).offset(54)
            make.leading.equalToSuperview().offset(24)
//            make.width.equalToSuperview().multipliedBy(0.477)
//            make.height.equalTo(titleLabel.snp.width).multipliedBy(0.402)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(38)
            make.leading.equalTo(titleLabel)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
