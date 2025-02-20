//
//  CompleteDeleteView.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/1/2025.
//

import UIKit

class CompleteDeleteView: UIView {
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP1(text: "회원탈퇴가 완료되었어요.", textColor: .black22))
    
    private let descriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "온마이웨이를 이용해주셔서 감사합니다. \n더 좋은 서비스를 제공하는 온마이웨이가 되겠습니다. \n나중에 다시 만나요!", textColor: .black66))
    
    private let omwImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "omwDeleteImage")
        return iv
    }()
    
    let completeButton = TitleButton(title: UIFont.CustomFont.button18(text: "확인", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
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
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(omwImageView)
        addSubview(completeButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 8))
            make.leading.equalTo(titleLabel)
        }
        
        omwImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 216))
            make.centerX.equalToSuperview()
            make.width.equalTo(LayoutAdapter.shared.scale(value: 212))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 194))
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
