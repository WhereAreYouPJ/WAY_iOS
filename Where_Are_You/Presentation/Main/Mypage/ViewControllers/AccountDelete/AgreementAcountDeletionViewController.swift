//
//  AgreementAcountDeletionViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/1/2025.
//

import UIKit

class AgreementAcountDeletionViewController: UIViewController {
    // MARK: - Properties

    private let agreementView = AgreementAcountDeletionView()
    var userName: String?
    
    // MARK: - Lifecycle
    init(userName: String? = nil) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = agreementView
        setupActions()
        setupNavigationBar()

        guard let userName = userName else { return }
        agreementView.configureUI(userName: userName, isFirstAgreement: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        configureNavigationBar(title: "회원탈퇴", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupActions() {
        agreementView.agreementCheckBoxButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        agreementView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func checkButtonTapped() {
        agreementView.agreementCheckBoxButton.isSelected.toggle() // 선택 상태 토글
        // 색상 변경
        agreementView.agreementCheckBoxButton.tintColor = agreementView.agreementCheckBoxButton.isSelected ? .brandColor : .color171
        let backGroundColor: UIColor = agreementView.agreementCheckBoxButton.isSelected ? .brandColor : .color171
        agreementView.nextButton.updateBackgroundColor(backGroundColor)
        agreementView.nextButton.isEnabled = agreementView.agreementCheckBoxButton.isSelected
    }
    
    @objc func nextButtonTapped() {
        print("nextbuttonTapped")
        let controller = CommentDeletionViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
