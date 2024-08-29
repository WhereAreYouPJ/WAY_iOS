//
//  MyDetailManageViewcontroller.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/8/2024.
//

import UIKit

class MyDetailManageViewcontroller: UIViewController {
    private let mydetailManageView = MyDetailManageView()
    private var userName: String = ""
    private var email: String = ""
    
    var viewModel: MyDetailManageViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mydetailManageView
        setupViewModel()
        setupBindings()
        setupNavigationBar()
    }
    
    // MARK: - Helpers
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = MyDetailManageViewModel(
            memberDetailsUseCase: MemberDetailsUseCaseImpl(memberRepository: memberRepository)
        )
    }
    
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "내 정보 관리", backButtonAction: #selector(backButtonTapped))
    }
    
    // TODO: 유저 정보가 표시가 안되는거 확인해보기.
    private func setupBindings() {
        viewModel.onGetMemberSuccess = { userName, email in
            self.setMemberDetail(userName: userName, email: email)
        }
    }
    
    private func setMemberDetail(userName: String, email: String) {
        mydetailManageView.userNameTextField.text = userName
        mydetailManageView.emailTextfield.text = email
    }
    
    // MARK: - Selectors

    @objc private func backButtonTapped() {
        // 네비게이션 바 뒤로가기 버튼
        dismiss(animated: true)
    }
}
