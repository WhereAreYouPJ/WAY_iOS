//
//  CommentDeletionViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/1/2025.
//

import UIKit

class CommentDeletionViewController: UIViewController {
    // MARK: - Properties
    private let commentDeletionView = AccountDeletionReasonView()
    private var viewModel: DeleteMemberViewModel!
    
    private let reasons = [
        "사용 빈도가 낮아서",
        "기능이 부족해서",
        "오류가 자주 발생해서",
        "개인정보 보호 문제",
        "서비스에 불만이 생겨서",
        "기타(직접입력)"
    ]
    
    private var selectedReasonIndex: Int? {
        didSet {
            updateNextButtonState()
            handleInputFieldVisibility()
        }
    }
    
    private var isShowingInputField: Bool = false {
        didSet {
            commentDeletionView.tableView.reloadData()
        }
    }
    
    private var inputText: String = "" // "기타(직접입력)" 내용 저장
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = commentDeletionView
        setupTableView()
        setupActions()
        setupNavigationBar()
    }
    
    // MARK: - Helpers
    private func setupTableView() {
        let tableView = commentDeletionView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
    }
    
    private func setupActions() {
        commentDeletionView.nextButton.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        configureNavigationBar(title: "회원탈퇴", backButtonAction: #selector(backButtonTapped))
    }
    
    private func updateNextButtonState() {
        let button = commentDeletionView.nextButton
        button.isEnabled = selectedReasonIndex != nil
        button.backgroundColor = selectedReasonIndex != nil ? .purple : .gray
    }
    
    private func handleInputFieldVisibility() {
        if selectedReasonIndex == reasons.count - 1 {
            isShowingInputField = true
        } else {
            isShowingInputField = false
        }
    }
    
    // MARK: - Selectors
    @objc private func handleNextButtonTapped() {
        if selectedReasonIndex == reasons.count - 1 {
            print("선택된 이유: \(reasons[selectedReasonIndex!])")
            print("직접 입력 내용: \(inputText)")
        } else {
            print("선택된 이유: \(reasons[selectedReasonIndex!])")
        }
        
        // 회원탈퇴 조건 재확인뷰로 이동
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CommentDeletionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count + (isShowingInputField ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "기타(직접입력)" 입력 필드 셀
        if isShowingInputField && indexPath.row == reasons.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InputFieldTableViewCell.identifier, for: indexPath) as? InputFieldTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(placeholder: "기타(직접입력)", text: inputText) { [weak self] text in
                self?.inputText = text
            }
            return cell
        }
        
        // 일반 이유 셀
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReasonSelectionTableViewCell.identifier, for: indexPath) as? ReasonSelectionTableViewCell else {
            return UITableViewCell()
        }
        let isSelected = selectedReasonIndex == indexPath.row
        cell.configure(reason: reasons[indexPath.row], isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 이미 선택된 항목이면 선택 취소
        if selectedReasonIndex == indexPath.row {
            selectedReasonIndex = nil
        } else {
            selectedReasonIndex = indexPath.row
        }
        
        tableView.reloadData() // 선택 상태를 반영하기 위해 테이블뷰 리로드
    }
}
