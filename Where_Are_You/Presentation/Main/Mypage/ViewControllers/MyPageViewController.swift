//
//  MyPageController.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/7/2024.
//

import UIKit
import PhotosUI

class MyPageViewController: UIViewController {
    // MARK: - Properties
    private let myPageView = MyPageView()
    private var viewModel: MyPageViewModel!
    private var userName: String?
    private var email: String?
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.memberDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 다음 화면으로 이동할 때 네비게이션 바 다시 표시
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = myPageView
        setupViewModel()
        setupBindings()
        setupActions()
        NotificationCenter.default.addObserver(self, selector: #selector(userNameDidChange), name: .userNameDidChange, object: nil)
    }
    
    // MARK: - Helpers
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = MyPageViewModel(
            logoutUseCase: LogoutUseCaseImpl(memberRepository: memberRepository),
            memberDetailsUseCase: MemberDetailsUseCaseImpl(memberRepository: memberRepository),
            modifyProfileImageUseCase: ModifyProfileImageUseCaseImpl(memberRepository: memberRepository)
        )
    }
    
    private func setupActions() {
        myPageView.setButtonActions(target: self, action: #selector(buttonTapped(_:)))
        myPageView.imageEditButton.addTarget(self, action: #selector(editImage), for: .touchUpInside)
        myPageView.moveToGallery.button.addTarget(self, action: #selector(moveToGallery), for: .touchUpInside)
        myPageView.logoutButton.button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
   
    private func setupBindings() {
        viewModel.onLogoutSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToLogin()
            }
        }
        
        viewModel.onGetMemberSuccess = { [weak self] memberDetails in
            DispatchQueue.main.async {
                guard let memberCode = UserDefaultsManager.shared.getMemberCode() else { return }
                let member = Member(userName: memberDetails.userName,
                                    profileImage: memberDetails.profileImage,
                                    memberCode: memberCode)
                self?.email = memberDetails.email
                self?.userName = memberDetails.userName
                self?.myPageView.configureUI(member: member)
            }
        }
        
        viewModel.onProfileImageUploadSuccess = { [weak self] in
            DispatchQueue.main.async {
                // 이미지 업로드 성공 시 UI 반영
                if let updatedImage = self?.myPageView.profileImageView.image {
                    self?.myPageView.profileImageView.image = updatedImage
                    print("프로필 이미지가 성공적으로 업데이트되었습니다.")
                }
            }
        }
    }
    
    private func navigateToLogin() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
    
    private func moveToDetailController(controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
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
        myPageView.moveToGallery.isHidden.toggle()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // Handle "내 정보 관리"
            moveToDetailController(controller: MyDetailManageViewcontroller(userName: userName, email: email))
        case 1:
            // Handle "위치 즐겨찾기"
            moveToDetailController(controller: LocationBookmarkViewController())
        case 2:
            // Handle "피드 책갈피"
            moveToDetailController(controller: FeedBookMarkViewController())
        case 3:
            // Handle "피드 보관함"
            moveToDetailController(controller: FeedArchiveViewController())
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

    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: myPageView)
        if !myPageView.moveToGallery.frame.contains(location) && !myPageView.imageEditButton.frame.contains(location) {
            myPageView.moveToGallery.isHidden = true
        }
    }
    
    @objc private func userNameDidChange() {
        // 유저 정보를 다시 불러오기
        viewModel.memberDetails()
    }
    
    @objc func moveToGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1  // 최대 선택 가능 사진 수
        configuration.filter = .images  // 이미지만 선택할 수 있도록 설정
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                print("이미지를 불러오는 중 오류 발생: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // UI에 선택된 이미지 반영
                    self.myPageView.profileImageView.image = image
                }
                
//                guard let imageURL = image.toURL() else {
//                    print("이미지를 URL로 변환하는데 실패")
//                    return
//                }
//                
//                let image = imageURL.absoluteString
                // 서버로 이미지 업로드
                self.viewModel.modifyProfileImage(image: image)
            }
        }
    }
}
