//
//  ViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/5/2024.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    // MARK: - Properties
    private let loginView = LoginView()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        
        buttonAction()
    }
    
    // MARK: - Helpers
    private func buttonAction() {
        loginView.kakaoLogin.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
        loginView.appleLogin.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        loginView.accountLogin.addTarget(self, action: #selector(accountLoginTapped), for: .touchUpInside)
        loginView.signupButton.button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        loginView.findAccountButton.button.addTarget(self, action: #selector(findAccountButtonTapped), for: .touchUpInside)
        loginView.inquiryButton.button.addTarget(self, action: #selector(inquiryButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func kakaoLoginTapped() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 앱으로 로그인 인증
            kakaoLonginWithApp()
        } else { // 카톡이 설치가 안 되어 있을 때
            // 카카오 계정으로 로그인
            kakaoLoginWithAccount()
        }
    }
    
    @objc func appleLoginTapped() {
        
    }
    
    @objc func accountLoginTapped() {
        let controller = AccountLoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func signupButtonTapped() {
        let controller = TermsAgreementViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func findAccountButtonTapped() {
        let controller = AccountSearchViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func inquiryButtonTapped() {

    }
    
    // MARK: Kakao Login
    
    func kakaoLonginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                
                //do something
                _ = oauthToken
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
            }
        }
    }
}
