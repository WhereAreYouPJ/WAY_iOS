//
//  FindAccountController.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/5/2024.
//

import UIKit

class SearchAccountController: UIViewController {
    // MARK: - Properties
    private let searchAccountOptionsView = SearchAccountOptionsView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchAccountOptionsView
        
        buttonAction()
        configureNavigationBar(title: "계정찾기", backButtonAction: #selector(backButtonTapped))
    }
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func searchID() {
        let controller = SearchIDViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func resetPassword() {
        let controller = SearchPasswordViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

    // MARK: - Helpers
    func buttonAction() {
        searchAccountOptionsView.findID.addTarget(self, action: #selector(searchID), for: .touchUpInside)
        searchAccountOptionsView.resetPassword.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
    }
}
