//
//  AgreementAcountDeletionView.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/1/2025.
//

import UIKit
import SnapKit

class AgreementAcountDeletionView: UIView {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 20))
        return label
    }()
    
    private let desriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .color118
        label.numberOfLines = 0

        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))
        return label
    }()
    
    private let firstInfoBox = CommonAccountBoxView()
    
    private let secondInfoBox = CommonAccountBoxView()
    
    let agreementCheckBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.tintColor = .color171
        return button
    }()
    
    private let buttonDesriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "모든 내용을 확인했으며 동의합니다."
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.textColor = .black22
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [agreementCheckBoxButton, buttonDesriptionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    let nextButton = CustomButton(title: "다음", backgroundColor: .color171, titleColor: .white, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))

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
        addSubview(desriptionLabel)
        addSubview(firstInfoBox)
        addSubview(secondInfoBox)
        addSubview(buttonStackView)
        addSubview(nextButton)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 30))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 21))
        }
        
        desriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 5))
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        firstInfoBox.snp.makeConstraints { make in
            make.top.equalTo(desriptionLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 30))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        secondInfoBox.snp.makeConstraints { make in
            make.top.equalTo(firstInfoBox.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.centerX.equalToSuperview()
            make.leading.equalTo(firstInfoBox)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(LayoutAdapter.shared.scale(value: -18))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 68))
            make.centerX.equalToSuperview()
            make.leading.equalTo(buttonStackView)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
    }
    
    func configureUI(userName: String?, isFirstAgreement: Bool) {
        if isFirstAgreement {
            guard let userName = userName else { return }
            titleLabel.text = "\(userName) 님, \n탈퇴하기 전에 꼭 확인해주세요."
            desriptionLabel.text = "탈퇴 후 재가입은 14일이 지나야 할 수 있어요."
            firstInfoBox.configureUI(title: "모든 피드와 일정 등 \n\(userName)님의 소중한 기록이 모두 사라져요.", description: "온마이웨이에서 계정 삭제 시 지금어디를 이용하며 기록된 모든 내용이 삭제돼요.")
            secondInfoBox.configureUI(title: "친구들로부터 \n\(userName)님의 계정이 사라져요.", description: "또한 다시 가입하더라도 친구를 다시 추가하려면 처음부터 친구 찾기와 요청 및 수락 확인을 다시 해야해요.")
        } else {
            buttonStackView.isHidden = true
            titleLabel.text = "정말 계정을 삭제하시겠어요?"
            desriptionLabel.text = "아래 내용을 다시 한 번 확인해 주세요."
            
            // Attributed string for red text in description
            let descriptionText = "계정 삭제 시 회원님의 프로필과 모든 콘텐츠는 \n즉시 영구적으로 삭제되며 다시 복구할 수 없습니다."
            let attributedDescription = NSMutableAttributedString(string: descriptionText)
            
            // Range of the text to color red
            if let range = descriptionText.range(of: "즉시 영구적으로 삭제되며 다시 복구할 수 없습니다.") {
                let nsRange = NSRange(range, in: descriptionText)
                attributedDescription.addAttribute(.foregroundColor, value: UIColor.error, range: nsRange)
            }
            
            firstInfoBox.configureUI(title: "모든 피드와 일정 등 \n 소중한 기록이 모두 사라져요.", attributedDescription: attributedDescription)
            secondInfoBox.configureUI(title: "친구들로부터 계정이 사라져요.", description: "내 프로필 및 콘텐츠가 다른 친구에게 공개되지 않습니다.")
        }
    }
}
