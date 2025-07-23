//
//  TermsAgreementViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/6/2024.
//

import UIKit

enum LoginType {
    case apple
    case kakao
    case account
}

class TermsAgreementViewController: UIViewController {
    // MARK: - Properties
    private let termsAgreementView = TermsAgreementView()
    private var isAgreed: Bool = false
    private var snsType: LoginType
    private var userName: String
    private var code: String
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = termsAgreementView
        
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
        buttonActions()
    }
    
    init(snsType: LoginType, userName: String = "", code: String = "") {
        self.snsType = snsType
        self.userName = userName
        self.code = code
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func buttonActions() {
        termsAgreementView.bottomButtonView.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
        termsAgreementView.agreeTermButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        // 각 "보기" 버튼에 target 추가
        for (index, button) in termsAgreementView.termButtons.enumerated() {
            button.tag = index  // 각 버튼을 식별하기 위해 태그를 설정
            button.addTarget(self, action: #selector(termButtonTapped(_:)), for: .touchUpInside)
        }
        
        for button in termsAgreementView.checkButtons {
            button.addTarget(self, action: #selector(individualCheckToggled(_:)), for: .touchUpInside)
        }
    }
    
    private func updateAgreeUI() {
        let buttons = termsAgreementView.checkButtons
        let required = termsAgreementView.requiredIndices
        let all = termsAgreementView.allIndices
        
        // 필수 약관만 모두 체크되었는지 여부
        let allRequiredAgreed = required.allSatisfy { buttons[$0].isSelected }
        
        // 전체 약관(필수 + 선택) 모두 체크되었는지 여부
        let allTotallyAgreed = all.allSatisfy { buttons[$0].isSelected }
        
        // 전체 동의 버튼은 전체 체크되었을 때만 선택 상태로 유지
        termsAgreementView.agreeTermButton.isSelected = allTotallyAgreed
        isAgreed = allTotallyAgreed
        
        termsAgreementView.agreeTermButton.tintColor = allTotallyAgreed ? .brandMain : .blackAC
        termsAgreementView.bottomButtonView.updateBackgroundColor(allRequiredAgreed ? .brandMain : .blackAC)
        termsAgreementView.bottomButtonView.isEnabled = allRequiredAgreed
    }
    
    private func updateButtonTintColor(_ button: UIButton) {
        button.tintColor = button.isSelected ? .brandMain : .blackAC
    }

    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        popViewController()
    }
    
    @objc func checkButtonTapped() {
        isAgreed.toggle()
        termsAgreementView.agreeTermButton.isSelected = isAgreed
        for button in termsAgreementView.checkButtons {
            button.isSelected = isAgreed
        }
        
        let allButtons = [termsAgreementView.agreeTermButton] + termsAgreementView.checkButtons
        allButtons.forEach {
            $0.isSelected = isAgreed
            updateButtonTintColor($0)
        }
        updateAgreeUI()
    }
    
    @objc func individualCheckToggled(_ sender: UIButton) {
        sender.isSelected.toggle()
        
//        // 필수 항목이 모두 체크되었는지 확인
//        let allRequiredAgreed = termsAgreementView.requiredIndices.allSatisfy {
//            termsAgreementView.checkButtons[$0].isSelected
//        }
//        
//        // 전체 동의 상태 갱신
//        isAgreed = allRequiredAgreed
//        termsAgreementView.agreeTermButton.isSelected = isAgreed

        updateButtonTintColor(sender)

        updateAgreeUI()
    }
    
    @objc func agreeButtonTapped() {
        if snsType == .account {
            let controller = SignUpFormViewController()
            pushToViewController(controller)
        } else {
            let controller = SocialSignUpViewController(code: code, userName: userName, snsType: snsType)
            pushToViewController(controller)
        }
    }
    
    @objc func termButtonTapped(_ sender: UIButton) {
        let (title, url): (String, String)

        switch sender.tag {
        case 0:
            title = "서비스 이용약관"
            url = "https://wlrmadjel.com/term-of-service"
        case 1:
            title = "개인정보 처리방침"
            url = "https://wlrmadjel.com/private-policy"
//        case 2:
//            title = "위치기반 서비스 이용약관"
//            url = "https://example.com/location-terms"
        default:
            return
        }
        
        let controller = TermsWebViewController(title: title, urlString: url)
        pushToViewController(controller)
    }
}
