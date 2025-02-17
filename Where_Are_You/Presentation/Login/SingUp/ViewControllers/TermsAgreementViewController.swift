//
//  TermsAgreementViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/6/2024.
//

import UIKit

class TermsAgreementViewController: UIViewController {
    // MARK: - Properties
    private let termsAgreementView = TermsAgreementView()
    private var isAgreed: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = termsAgreementView
        
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
        buttonActions()
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
    }
    
    private func updateAgreeUI() {
        if isAgreed {
            // 동의 상태일 때: agreeTermButton과 bottomButtonView 모두 brandMain 색으로 변경하고, bottomButtonView 활성화
            termsAgreementView.agreeTermButton.tintColor = .brandMain
            termsAgreementView.bottomButtonView.updateBackgroundColor(.brandMain)
            termsAgreementView.bottomButtonView.isEnabled = true
        } else {
            // 미동의 상태일 때: 기본 색상으로 변경 및 bottomButtonView 비활성화
            termsAgreementView.agreeTermButton.tintColor = .blackAC
            termsAgreementView.bottomButtonView.updateBackgroundColor(.blackAC)
            termsAgreementView.bottomButtonView.isEnabled = false
        }
    }
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func checkButtonTapped() {
        isAgreed.toggle()
        updateAgreeUI()
    }
    
    @objc func agreeButtonTapped() {
        let controller = SignUpFormViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func termButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // 서비스 이용약관 "보기" 버튼 탭 처리
            print("서비스 이용약관 보기")
            // 예: 서비스 이용약관 페이지로 이동
        case 1:
            // 개인정보 처리방침 "보기" 버튼 탭 처리
            print("개인정보 처리방침 보기")
            // 예: 개인정보 처리방침 페이지로 이동
        case 2:
            // 위치기반 서비스 이용약관 "보기" 버튼 탭 처리
            print("위치기반 서비스 이용약관 보기")
            // 예: 위치기반 서비스 이용약관 페이지로 이동
        default:
            break
        }
    }
}
