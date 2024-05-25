//
//  ViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/5/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let loginView = LoginView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Helpers
    
    func setupView() {
        view.addSubview(loginView)
        loginView.frame = view.bounds
    }

}
