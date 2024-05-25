//
//  AccountLoginController.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

class AccountLoginController: UIViewController {
    // MARK: - Properties
    
    private let accountView = AccountLogin()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .white
    }
    
    func setupView() {
        view.addSubview(accountView)
    }

}
