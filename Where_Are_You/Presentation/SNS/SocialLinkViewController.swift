//
//  SocialLinkViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/2/2025.
//

import UIKit

class SocialLinkViewController: UIViewController {
    // MARK: - Properties
    let socialLinkView = SocialLinkView()
    private var viewModel: SocialLinkViewModel!
    
    var email: String = ""
    private var password: String = ""
    private var userName: String = ""
    private var loginType: String = ""
    private var linkLoginType: [String] = []
    
    // MARK: - Lifecycle
    init(email: String, password: String, userName: String, loginType: String, linkLoginType: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.email = email
        self.password = password
        self.userName = userName
        self.loginType = loginType
        self.linkLoginType = linkLoginType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupBindings()
        setupActions()
    }
    
    // MARK: - Helpers
    
    private func setupUI() {
        view = socialLinkView
        socialLinkView.configureAccountView(snsAccounts: linkLoginType, email: email)
        if linkLoginType.count == 1 {
            if linkLoginType.first == loginType {
                socialLinkView.linkButton.isHidden = true
            }
        }
        
        configureNavigationBar(title: "회원가입", showBackButton: false)
    }
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = SocialLinkViewModel(
            accountLinkUseCase: AccountLinkUseCaseImpl(memberRepository: memberRepository))
    }
    
    private func setupBindings() {
        viewModel.onSignUpSuccess = { [weak self] in
            self?.moveToSignUpSuccess()
        }
    }
    
    private func setupActions() {
        socialLinkView.returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        socialLinkView.linkButton.addTarget(self, action: #selector(accountLinkButtonTapped), for: .touchUpInside)
    }
    
    private func moveToSignUpSuccess() {
        let controller = FinishRegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc private func returnButtonTapped() {
        let controller = LoginViewController()
        rootToViewcontroller(controller)
    }
    
    @objc private func accountLinkButtonTapped() {
        viewModel.linkAccount(userName: userName, email: email, password: password, loginType: loginType)
    }
}
