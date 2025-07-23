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
    
    var userName: String
    var email: String
        
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
    init(userName: String, email: String) {
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
        mydetailManageView.emailStack.isHidden = false
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
        configureNavigationBar(title: "내 정보 관리", backButtonAction: #selector(backButtonTapped), rightButton: UIBarButtonItem(customView: addButton))
    }
    
    private func buttonActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        mydetailManageView.modifyButton.button.addTarget(self, action: #selector(modifyButtonTapped), for: .touchUpInside)
        mydetailManageView.updateDetailButton.addTarget(self, action: #selector(updateDetailButtonTapped), for: .touchUpInside)
        mydetailManageView.userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
//        view.addGestureRecognizer(tapGesture)
    }
   
    // 초기 설정
    private func configureInitialState() {
        if email.isEmpty {
            mydetailManageView.emailStack.isHidden = true
        } else {
            mydetailManageView.emailStack.isHidden = false
            mydetailManageView.emailTextfield.setupTextField(placeholder: email)
            mydetailManageView.emailTextfield.isUserInteractionEnabled = false
            mydetailManageView.emailTextfield.backgroundColor = .blackF0
            mydetailManageView.userNameTextField.isUserInteractionEnabled = isEditingMode
            mydetailManageView.updateDetailButton.isHidden = !isEditingMode
            addButton.isHidden = isEditingMode
            mydetailManageView.userNameTextField.setupTextField(placeholder: userName)
        }
    }
    
    private func setupBindings() {
        viewModel.onChangeNameSuccess = { [weak self] userName in
            DispatchQueue.main.async {
                self?.userName = userName
                self?.mydetailManageView.userNameTextField.setupTextField(placeholder: userName)
                self?.mydetailManageView.userNameTextField.isEnabled = false
                self?.mydetailManageView.updateDetailButton.updateTitle("수정되었습니다")
                self?.mydetailManageView.updateDetailButton.updateBackgroundColor(.blackAC)
            }
        }
        
        viewModel.onUserNameValidationMessage = { [weak self] isAvailable in
            DispatchQueue.main.async {
                self?.updateStatus(label: self?.mydetailManageView.userNameErrorLabel, isAvailable: isAvailable, textField: self?.mydetailManageView.userNameTextField)
            }
        }
    }
    
    // MARK: - Selectors
    @objc private func backButtonTapped() {
        popViewController()
        NotificationCenter.default.post(name: .userNameDidChange, object: nil)
    }
    
    @objc private func addButtonTapped() {
        mydetailManageView.modifyButton.isHidden.toggle()
    }
    
    @objc private func modifyButtonTapped() {
        isEditingMode.toggle()
        mydetailManageView.modifyButton.isHidden = true
        configureInitialState()
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
    
    // 이름 조건 확인 -> 상태 변경
    private func updateStatus(label: UILabel?, isAvailable: Bool, textField: UITextField?) {
        label?.isHidden = isAvailable
        if let customTF = textField as? CustomTextField {
            // 조건이 맞지 않으면 error 상태를 유지하도록 설정
            customTF.setErrorState(!isAvailable)
        }
        mydetailManageView.updateDetailButton.isEnabled = isAvailable
        mydetailManageView.updateDetailButton.updateBackgroundColor(isAvailable ? .brandMain : .blackAC)
    }
}

extension NSNotification.Name {
    static let userNameDidChange = NSNotification.Name("userNameDidChange")
}
