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
    private var isEditingMode = false
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-plus"), for: .normal)
        button.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 34))
        }
        button.tintColor = .brandColor
        return button
    }()
    
    var viewModel: MyDetailManageViewModel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mydetailManageView
        setupViewModel()
        setupNavigationBar()
        buttonActions()
        configureInitialState()
        setupBindings()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    private func buttonActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        mydetailManageView.modifyButton.addTarget(self, action: #selector(modifyButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func configureInitialState() {
        // 초기에는 수정이 불가능한 상태로 설정
        mydetailManageView.userNameTextField.textColor = .color102
        mydetailManageView.emailTextfield.textColor = .color102
        mydetailManageView.userNameTextField.isUserInteractionEnabled = false
        mydetailManageView.emailTextfield.isUserInteractionEnabled = false
        mydetailManageView.updateDetailButton.isHidden = true
        addButton.isHidden = false
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
        isEditingMode = false
        dismiss(animated: true)
    }
    
    @objc private func addButtonTapped() {
        mydetailManageView.modifyButton.isHidden.toggle()
    }
    
    @objc func modifyButtonTapped() {
        print("수정하기 버튼 눌림")
        isEditingMode.toggle()  // 수정 모드 토글
        print(isEditingMode)
        
        // 수정 모드에 따라 UI 업데이트
        if isEditingMode {
            mydetailManageView.userNameTextField.isUserInteractionEnabled = true
            mydetailManageView.userNameTextField.textColor = .color34
            mydetailManageView.emailTextfield.isUserInteractionEnabled = false  // 이메일 수정 불가
            mydetailManageView.emailLabel.textColor = .color153
            mydetailManageView.emailTextfield.textColor = .color153 // 이메일 색상 변경
            mydetailManageView.updateDetailButton.isHidden = false
            addButton.isHidden = true
        } else {
            configureInitialState()
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mydetailManageView)
        if !addButton.frame.contains(location) && !mydetailManageView.modifyButton.frame.contains(location) {
            mydetailManageView.modifyButton.isHidden = true
        }
    }
}
