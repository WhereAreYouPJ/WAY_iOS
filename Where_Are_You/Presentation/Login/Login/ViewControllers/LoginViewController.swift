//
//  ViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/5/2024.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let loginView = LoginView()
    private var viewModel: AccountLoginViewModel!
    private var snsLoginViewModel: LoginViewModel! // 소셜로그인 뷰모델
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        view.backgroundColor = .white
        setupViewModel()
        buttonAction()
        setupBindings()
    }
    
    // MARK: - Helpers
    private func buttonAction() {
        loginView.kakaoLogin.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
        loginView.appleLogin.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        loginView.accountLogin.addTarget(self, action: #selector(accountLoginTapped), for: .touchUpInside)
        loginView.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        loginView.findAccountButton.addTarget(self, action: #selector(findAccountButtonTapped), for: .touchUpInside)
        loginView.inquiryButton.addTarget(self, action: #selector(inquiryButtonTapped), for: .touchUpInside)
    }
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = AccountLoginViewModel(
            accountLoginUseCase: AccountLoginUseCaseImpl(memberRepository: memberRepository),
            appleLoginUseCase: AppleLoginUseCaseImpl(memberRepository: memberRepository))
        
        let kakaoLoginUseCase = KakaoLoginUseCaseImpl(memberRepository: memberRepository)
        snsLoginViewModel = LoginViewModel(kakaoLoginUseCase: kakaoLoginUseCase)
        
        setupKakaoBindings()
    }
    
    private func setupBindings() {
        viewModel.onAppleLoginState = { [weak self] state, code in
            if state {
                let controller = MainTabBarController()
                self?.rootToViewcontroller(controller)
            } else {
                let controller = TermsAgreementViewController(snsType: .apple, code: code)
                self?.pushToViewController(controller)
            }
        }
    }
    
    // 카카오 로그인 결과 처리
    private func setupKakaoBindings() {
        snsLoginViewModel.onLoginResult = { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: // 로그인 성공 -> 메인 화면으로
                    let controller = MainTabBarController()
                    let nav = UINavigationController(rootViewController: controller)
                    nav.modalPresentationStyle = .fullScreen
                    self?.present(nav, animated: true, completion: nil)
                case .failure(let error): // 로그인 실패
                    print("카카오 로그인 실패: \(error)")
                    self?.view.makeToast("로그인에 실패했습니다.", duration: 2.0)
                }
            }
        }
        
        // 회원가입이 필요한 경우 TODO: 추후 소셜 회원가입 로직 수정되면 해당 코드 수정되어야.
        snsLoginViewModel.onNeedKakaoSignup = { [weak self] authCode in
            DispatchQueue.main.async {
                // 카카오 회원가입 화면으로 이동
                let signUpVC = SocialSignUpViewController(code: authCode, userName: "", snsType: .kakao)
                self?.pushToViewController(signUpVC)
            }
        }
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
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func accountLoginTapped() {
        let controller = AccountLoginController()
        pushToViewController(controller)
    }
    
    @objc func signupButtonTapped() {
        let controller = TermsAgreementViewController(snsType: .account)
        pushToViewController(controller)
    }
    
    @objc func findAccountButtonTapped() {
        let controller = AccountSearchViewController()
        pushToViewController(controller)
    }
    
    @objc func inquiryButtonTapped() {
        let controller = InquiryViewController()
        pushToViewController(controller)
    }
    
    // MARK: Kakao Login
    func kakaoLonginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print("카카오톡 로그인 실패: \(error)")
            } else if let token = oauthToken {
                print("카카오톡 로그인 성공")
                self.snsLoginViewModel.kakaoLogin(authCode: token.accessToken)
            }
        }
    }
    
    func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print("카카오 계정 로그인 실패: \(error)")
            } else if let token = oauthToken {
                print("카카오 계정 로그인 성공")
                self.snsLoginViewModel.kakaoLogin(authCode: token.accessToken)
            }
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
                
                viewModel.appleLogin(code: identifyTokenString)
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(String(describing: fullName))")
            print("email: \(String(describing: email))")
            
            //            if let email = email {
            //                // email 값이 있으면 신규 회원가입으로 간주하거나,
            //                // 백엔드에서 회원 존재 여부를 체크하는 API를 호출합니다.
            //                // 예를 들어, 신규 회원가입 화면으로 이동합니다.
            //            } else {
            //                // email 값이 nil이면 이미 가입된 계정으로 간주합니다.
            //                // 이 경우, 백엔드 API 호출을 통해 로그인 처리를 진행하거나 바로 메인 화면으로 이동합니다.
            //            }
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
