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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(termsAgreementView)
        termsAgreementView.frame = view.bounds
        
        configureNavigationBar(title: "회원가입", backButtonAction: #selector(backButtonTapped))
        
        buttonActions()
    }
    
    // MARK: - Helpers
    
    func buttonActions() {
        termsAgreementView.agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func agreeButtonTapped() {
        let controller = SignUpFormViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
