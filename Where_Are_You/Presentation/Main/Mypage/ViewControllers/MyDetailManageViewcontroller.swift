//
//  MyDetailManageViewcontroller.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/8/2024.
//

import UIKit

class MyDetailManageViewcontroller: UIViewController {
    private let mydetailManageView = MyDetailManageView()
    private var isEditingMode = false
    
    var userName: String?
    var email: String?
        
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
    init(userName: String? = nil, email: String? = nil) {
        self.userName = userName
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mydetailManageView
        configureInitialState()
        setupViewModel()
        setupNavigationBar()
        buttonActions()
        setupBindings()
    }
    
    // MARK: - Helpers
    private func setupViewModel() {
        let memberService = MemberService()
        let memberRepository = MemberRepository(memberService: memberService)
        viewModel = MyDetailManageViewModel(
            modifyUserNameUseCase: ModifyUserNameUseCaseImpl(memberRepository: memberRepository)
        )
    }
    
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "내 정보 관리", backButtonAction: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
    }
    
    private func buttonActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        mydetailManageView.modifyButton.button.addTarget(self, action: #selector(modifyButtonTapped), for: .touchUpInside)
        mydetailManageView.updateDetailButton.addTarget(self, action: #selector(updateDetailButtonTapped), for: .touchUpInside)
        mydetailManageView.userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
   
    private func configureInitialState() {
        // 초기에는 수정이 불가능한 상태로 설정
        mydetailManageView.userNameTextField.text = userName
        mydetailManageView.userNameTextField.textColor = .color102
        mydetailManageView.userNameTextField.isUserInteractionEnabled = false
        mydetailManageView.emailTextfield.text = email
        mydetailManageView.emailTextfield.textColor = .color102
        mydetailManageView.emailTextfield.isUserInteractionEnabled = false
        mydetailManageView.updateDetailButton.isHidden = true
        addButton.isHidden = false
    }
    
    private func setupBindings() {
        viewModel.onChangeNameSuccess = { [weak self] in
            // TODO: 여기에 화면을 이동하는지 토스트 메시지만 띄우는지 확인하고 추가하기
        }
        
        viewModel.onUserNameValidationMessage = { [weak self] isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.mydetailManageView.userNameErrorLabel, isAvailable: isAvailable, textField: self?.mydetailManageView.userNameTextField)
            }
        }
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
    
    @objc private func modifyButtonTapped() {
        isEditingMode.toggle()  // 수정 모드 토글
        mydetailManageView.modifyButton.isHidden = true
        
        // 수정 모드에 따라 UI 업데이트
        if isEditingMode {
            mydetailManageView.userNameTextField.isUserInteractionEnabled = true
            mydetailManageView.userNameTextField.textColor = .color34
            mydetailManageView.emailTextfield.isUserInteractionEnabled = false
            mydetailManageView.emailLabel.textColor = .color153
            mydetailManageView.emailTextfield.textColor = .color153
            mydetailManageView.updateDetailButton.isHidden = false
            addButton.isHidden = true
        } else {
            configureInitialState()
        }
        
        self.view.layoutIfNeeded()
    }
    
    @objc private func updateDetailButtonTapped() {
        guard let userName = mydetailManageView.userNameTextField.text else { return }
        viewModel.modifyUserName(userName: userName)
    }
    
    @objc private func textFieldDidChange() {
        guard let userName = mydetailManageView.userNameTextField.text else { return }
        viewModel.checkUserNameValidation(userName: userName)
    }
    
    @objc private func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mydetailManageView)
        if !addButton.frame.contains(location) && !mydetailManageView.modifyButton.frame.contains(location) {
            mydetailManageView.modifyButton.isHidden = true
        }
    }
    
    private func updateStatus(label: UILabel?, isAvailable: Bool, textField: UITextField?) {
        label?.isHidden = isAvailable
        textField?.layer.borderColor = isAvailable ? UIColor.color212.cgColor : UIColor.warningColor.cgColor
        mydetailManageView.updateDetailButton.isEnabled = isAvailable
        mydetailManageView.updateDetailButton.backgroundColor = isAvailable ? .brandColor : .color171
    }
}
