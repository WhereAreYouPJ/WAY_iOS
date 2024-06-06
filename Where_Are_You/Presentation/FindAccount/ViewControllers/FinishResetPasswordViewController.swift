//
//  FinishResetPasswordViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit

class FinishResetPasswordViewController: UIViewController {
    
    let finisView = FinishResetPasswordView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(finisView)
        finisView.frame = view.bounds
        
        configureNavigationBar(title: "비밀번호 찾기")
        buttonActions()
    }
    
    // MARK: - Selectors
    
    @objc func goToLogin() {
        let controller = AccountLoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Helpers

    func buttonActions() {
        finisView.bottomButtonView.button.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
    }
    
}
