//
//  FinishResetPasswordViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit

class PasswordFinishResetViewController: UIViewController {
    
    let passwordFinishResetView = PasswordFinishResetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = passwordFinishResetView
        
        configureNavigationBar(title: "비밀번호 재설정")
        buttonActions()
    }
    
    // MARK: - Selectors
    
    @objc func goToLogin() {
        let controller = LoginViewController()
        rootToViewcontroller(controller)
    }
    
    // MARK: - Helpers

    func buttonActions() {
        passwordFinishResetView.bottomButtonView.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
    }
}
