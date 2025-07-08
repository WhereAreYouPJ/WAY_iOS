//
//  FinishRegisterViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 6/6/2024.
//

import UIKit

class FinishRegisterViewController: UIViewController {
    // MARK: - Properties
    
    let finishView = FinishRegisterview()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = finishView
        
        configureNavigationBar(title: "회원가입")
        buttonActions()
    }
    
    // MARK: - Helpers
    
    func buttonActions() {
        finishView.bottomButtonView.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    // MARK: - Selectors
    @objc func loginButtonTapped() {
        let controller = LoginViewController()
        rootToViewcontroller(controller)
    }
}
