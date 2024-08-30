//
//  MyPageController.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/7/2024.
//

import UIKit

class MyPageViewController: UIViewController {
    // MARK: - Properties
    
    private let myPageView = MyPageView()
    private var viewModel: MyPageViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = myPageView
        setupViewModel()
        setupActions()
        setupBindings()
        myPageView.userCodeLabel.text = UserDefaultsManager.shared.getMemberCode()
    }
    
    // MARK: - Helpers
    
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = MyPageViewModel(
            logoutUseCase: LogoutUseCaseImpl(memberRepository: memberRepository)
        )
    }
    
    private func setupActions() {
        myPageView.setButtonActions(target: self, action: #selector(buttonTapped(_:)))
        myPageView.imageEditButton.addTarget(self, action: #selector(editImage), for: .touchUpInside)
        myPageView.moveToGallery.addTarget(self, action: #selector(moveToGallery), for: .touchUpInside)
        myPageView.userNameEditButton.addTarget(self, action: #selector(editUserName), for: .touchUpInside)
        myPageView.logoutButton.button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupBindings() {
        viewModel.onLogoutSuccess = { [weak self] in
            self?.navigateToLogin()
        }
    }
    
    private func navigateToLogin() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        // 윈도우에 접근하여 루트 뷰 컨트롤러 변경
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
    
    // MARK: - Selectors
    @objc func logoutButtonTapped() {
        let alert = CustomAlert(
            title: "로그아웃",
            message: "로그아웃을 진행하시겠습니까?",
            cancelTitle: "취소",
            actionTitle: "학인"
        ) { [weak self] in
                self?.viewModel.logout()
            }
        alert.showAlert(on: self)
    }
    
    @objc private func editImage() {
        // 프로필 이미지 수정
        myPageView.moveToGallery.isHidden.toggle()
    }
    
    @objc private func moveToGallery() {
        // 갤러리 이동
        print("갤러리 이동하기")
    }
    
    @objc private func editUserName() {
        // 유저이름 수정
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // Handle "내 정보 관리"
            moveToDetailController(controller: MyDetailManageViewcontroller())
        case 1:
            // Handle "위치 즐겨찾기"
            print("위치 즐겨찾기 tapped")
        case 2:
            // Handle "피드 책갈피"
            print("피드 책갈피 tapped")
        case 3:
            // Handle "피드 보관함"
            print("피드 보관함 tapped")
        case 4:
            // Handle "공지사항"
            print("공지사항 tapped")
        case 5:
            // Handle "1:1 이용문의"
            print("1:1 이용문의 tapped")
        default:
            break
        }
    }
    
    private func moveToDetailController(controller: UIViewController) {
        // TODO: 추후에 view를 탭바 위에 뜨는걸로 바꾸어야 함
        let controller = controller
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: myPageView)
        if !myPageView.moveToGallery.frame.contains(location) && !myPageView.imageEditButton.frame.contains(location) {
            myPageView.moveToGallery.isHidden = true
        }
    }
}
