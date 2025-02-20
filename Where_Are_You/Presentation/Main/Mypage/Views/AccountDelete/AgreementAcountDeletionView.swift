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
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP1(text: "", textColor: .black22))
    
    private let desriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "", textColor: .black66))
    
    private let firstInfoBox = CommonAccountBoxView()
    
    private let secondInfoBox = CommonAccountBoxView()
    
    let agreementCheckBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.tintColor = .color171
        return button
    }()
    
    private let buttonDesriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "모든 내용을 확인했으며 동의합니다.", textColor: .black22))
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [agreementCheckBoxButton, buttonDesriptionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let nextButton = TitleButton(title: UIFont.CustomFont.button18(text: "다음", textColor: .white), backgroundColor: .blackAC, borderColor: nil)

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
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        desriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 4))
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        firstInfoBox.snp.makeConstraints { make in
            make.top.equalTo(desriptionLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 24))
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        secondInfoBox.snp.makeConstraints { make in
            make.top.equalTo(firstInfoBox.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
            make.centerX.equalToSuperview()
            make.leading.equalTo(firstInfoBox)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(LayoutAdapter.shared.scale(value: -18))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
    
    func configureUI(userName: String?, isFirstAgreement: Bool) {
        if isFirstAgreement {
            guard let userName = userName else { return }
            titleLabel.attributedText = UIFont.CustomFont.bodyP1(text: "\(userName) 님, \n탈퇴하기 전에 꼭 확인해주세요.", textColor: .black22)
            desriptionLabel.attributedText = UIFont.CustomFont.bodyP4(text: "탈퇴 후 재가입은 14일이 지나야 할 수 있어요.", textColor: .black66)
            firstInfoBox.configureUI(title: "모든 피드와 일정 등 \n\(userName)님의 소중한 기록이 모두 사라져요.", description: "온마이웨이에서 계정 삭제 시 지금어디를 이용하며 기록된 모든 내용이 삭제돼요.")
            secondInfoBox.configureUI(title: "친구들로부터 \n\(userName)님의 계정이 사라져요.", description: "또한 다시 가입하더라도 친구를 다시 추가하려면 처음부터 친구 찾기와 요청 및 수락 확인을 다시 해야해요.")
        } else {
            buttonStackView.isHidden = true
            titleLabel.attributedText = UIFont.CustomFont.bodyP1(text: "정말 계정을 삭제하시겠어요?", textColor: .black22)
            desriptionLabel.attributedText = UIFont.CustomFont.bodyP4(text: "아래 내용을 다시 한 번 확인해 주세요.", textColor: .black66)
            
            // Attributed string for red text in description
            let descriptionText = "계정 삭제 시 회원님의 프로필과 모든 콘텐츠는 \n즉시 영구적으로 삭제되며 다시 복구할 수 없습니다."

            let baseAttributed = UIFont.CustomFont.bodyP4(text: "계정 삭제 시 회원님의 프로필과 모든 콘텐츠는 \n즉시 영구적으로 삭제되며 다시 복구할 수 없습니다.", textColor: .black66)
            let attributedDescription = NSMutableAttributedString(attributedString: baseAttributed)
            
            // Range of the text to color red
            if let range = descriptionText.range(of: "즉시 영구적으로 삭제되며 다시 복구할 수 없습니다.") {
                let nsRange = NSRange(range, in: descriptionText)
                attributedDescription.addAttribute(.foregroundColor, value: UIColor.error, range: nsRange)
            }
            
            firstInfoBox.configureUI(title: "모든 피드와 일정 등 \n소중한 기록이 모두 사라져요.", attributedDescription: attributedDescription)
            secondInfoBox.configureUI(title: "친구들로부터 계정이 사라져요.", description: "내 프로필 및 콘텐츠가 다른 친구에게 공개되지 않습니다.")
        }
    }
}
