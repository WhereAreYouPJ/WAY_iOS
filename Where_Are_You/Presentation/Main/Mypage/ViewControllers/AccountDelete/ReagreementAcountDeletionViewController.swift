//
//  ReagreementAcountDeletionViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/1/2025.
//

import UIKit

class ReagreementAcountDeletionViewController: UIViewController {
    // MARK: - Properties
    private let agreementView = AgreementAcountDeletionView()
    private var comment: String = ""
    
    // MARK: - Lifecycle
    
    init(comment: String) {
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = agreementView
        setupUI()
        setupActions()
        setupNavigationBar()
    }

    // MARK: - Helpers
    private func setupUI() {
        agreementView.configureUI(userName: nil, isFirstAgreement: false)
        agreementView.nextButton.updateBackgroundColor(.brandColor)
    }
    
    private func setupNavigationBar() {
        configureNavigationBar(title: "회원탈퇴", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupActions() {
        agreementView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    @objc func nextButtonTapped() {
        let controller = CheckPasswordViewController(comment: comment)
        navigationController?.pushViewController(controller, animated: true)
    }
}
