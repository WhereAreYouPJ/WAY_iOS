//
//  CompleteDeleteViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/1/2025.
//

import UIKit

class CompleteDeleteViewController: UIViewController {
    // MARK: - Properties
    let completeDeleteView = CompleteDeleteView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Helpers

    private func setupUI() {
        view = completeDeleteView
        configureNavigationBar(title: "회원 탈퇴")
    }
    
    private func setupActions() {
        completeDeleteView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors

    @objc func completeButtonTapped() {
        let controller = LoginViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
