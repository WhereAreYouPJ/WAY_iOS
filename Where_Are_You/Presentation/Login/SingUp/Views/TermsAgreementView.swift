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
    var termButtons: [UIButton] = []

    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .blackF0
        return view
    }()
    
    private let colorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .brandMain
        view.layer.cornerRadius = 3
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "회원가입에 필요한 \n약관에 동의해주세요", textColor: .black22))
    
    private let agreeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.shadowOffset = CGSize(width: 0, height: -6)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.04
        view.layer.shadowRadius = 6
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: -6, width: UIScreen.main.bounds.width, height: 192 + 6), cornerRadius: 24)
        view.layer.shadowPath = shadowPath.cgPath
        return view
    }()
    
    let agreeTermButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icon-checkBox")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .blackAC
        return button
    }()
    
    private let agreeTitle = StandardLabel(UIFont: UIFont.CustomFont.bodyP2(text: "모두 동의하기", textColor: .black22))
    
    private lazy var termTitleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [agreeTermButton, agreeTitle])
        sv.axis = .horizontal
        sv.spacing = 0
        return sv
    }()
    
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "동의하고 시작하기", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
        setupTermsAgreement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewComponents() {
        addSubview(progressBar)
        progressBar.addSubview(colorBar)
        addSubview(titleLabel)
        addSubview(bottomButtonView)
        addSubview(agreeView)
        agreeView.addSubview(termTitleStackView)
    }
    
    private func setupConstraints() {
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        colorBar.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.333)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(51)
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        agreeView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButtonView.snp.top).offset(LayoutAdapter.shared.scale(value: -12))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 192))
            make.leading.trailing.equalToSuperview()
        }
        
        termTitleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 30))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 27))
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
    
    private func createTermRow(title: String) -> UIStackView {
        // 약관 제목을 표시하는 라벨
        let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: title, textColor: .black22))
        
        // "보기" 버튼 생성
        let viewButton = StandardButton(text: UIFont.CustomFont.bodyP3(text: "보기", textColor: .black66))
        viewButton.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        termButtons.append(viewButton)

        // 가로 스택 뷰에 라벨과 버튼 추가
        let rowStack = UIStackView(arrangedSubviews: [titleLabel, viewButton])
        rowStack.axis = .horizontal
        rowStack.spacing = 0
        
        // 라벨과 버튼 사이의 공간을 유연하게 분배하려면 라벨의 content hugging priority를 낮게 설정 가능
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        viewButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return rowStack
    }
    
    private func setupTermsAgreement() {
        // 약관 항목들을 배열로 정의
        let terms = [
            "서비스 이용약관 (필수)",
            "개인정보 처리방침 (필수)",
            "위치기반 서비스 이용약관 (필수)"
        ]
        
        // 각 항목에 대해 rowStack을 생성하여 배열에 담습니다.
        let termRows = terms.map { createTermRow(title: $0) }
        
        // 세로 스택 뷰 생성
        let termsStackView = UIStackView(arrangedSubviews: termRows)
        termsStackView.axis = .vertical
        termsStackView.spacing = 8
        
        // agreeView에 추가
        agreeView.addSubview(termsStackView)
        
        // 약관 스택 뷰의 제약 조건 설정 (예: agreeView의 상하좌우에 일정 간격)
        termsStackView.snp.makeConstraints { make in
            make.top.equalTo(termTitleStackView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 32))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 27))
        }
    }
}
