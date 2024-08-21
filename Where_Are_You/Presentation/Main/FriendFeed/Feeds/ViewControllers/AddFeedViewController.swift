//
//  AddFeedViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/8/2024.
//

import UIKit

class AddFeedViewController: UIViewController {
    // MARK: - Properties
    
    let addFeedView = AddFeedView()
    private var dropViewHeightConstraint: NSLayoutConstraint!
    private var isDropdownVisible = false
    private var contentTextViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addFeedView
        setupNavigationBar()
        buttonActions()
        setupUI()
    }
    
    // MARK: - Helpers
    
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "새 피드 작성", backButtonAction: #selector(backButtonTapped), showBackButton: true)
    }
    
    private func setupUI() {
        dropViewHeightConstraint = addFeedView.scheduleDropDown.heightAnchor.constraint(equalToConstant: LayoutAdapter.shared.scale(value: 50))
        dropViewHeightConstraint.isActive = true
        
        addFeedView.contentTextView.delegate = self
        
        // 텍스트 뷰의 높이 제약 조건 저장
        contentTextViewHeightConstraint = addFeedView.contentTextView.heightAnchor.constraint(equalToConstant: LayoutAdapter.shared.scale(value: 110))
        contentTextViewHeightConstraint.isActive = true
    }
    
    private func buttonActions() {
        addFeedView.scheduleDropDown.scheduleDropDownView.addTarget(self, action: #selector(dropDownButtonTapped), for: .touchUpInside)
        addFeedView.addImages.addTarget(self, action: #selector(addImagesTapped), for: .touchUpInside)
        addFeedView.creatFeedButton.button.addTarget(self, action: #selector(createFeed), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func dropDownButtonTapped() {
        isDropdownVisible.toggle()
        let iconName = isDropdownVisible ? "chevron.up" : "chevron.down"
        addFeedView.scheduleDropDown.dropDownButton.image = UIImage(systemName: iconName)
        
        dropViewHeightConstraint.constant = isDropdownVisible ? LayoutAdapter.shared.scale(value: 356) : LayoutAdapter.shared.scale(value: 50) // 테이블 뷰 포함 높이 조정
        addFeedView.scheduleDropDown.dropDownTableView.isHidden = !isDropdownVisible // 테이블 뷰 표시/숨김 처리
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func addImagesTapped() {
        // 사진 추가 버튼 눌림
    }
    
    @objc func createFeed() {
        // 피드 생성하기 버튼 눌림
    }
}

extension AddFeedViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .color118 else { return }
        textView.text = nil
        textView.textColor = .color34
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "어떤 일이 있었나요?"
            textView.textColor = .color118
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        contentTextViewHeightConstraint.constant = max(estimatedSize.height, LayoutAdapter.shared.scale(value: 110))
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
