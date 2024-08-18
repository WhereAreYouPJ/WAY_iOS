//
//  AddFeedViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/8/2024.
//

import UIKit

class AddFeedViewController: UIViewController {
    // MARK: - Properties

    let addFeedView = ScheduleDropDownView()
    
    var dropViewHeightConstraint: NSLayoutConstraint!
    var isDropdownVisible = false
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(addFeedView)
        setupNavigationBar()
        buttonActions()
    }
    // MARK: - Helpers

    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "새 피드 작성", backButtonAction: #selector(backButtonTapped), showBackButton: true)
        
        addFeedView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        dropViewHeightConstraint = addFeedView.heightAnchor.constraint(equalToConstant: LayoutAdapter.shared.scale(value: 50))
                dropViewHeightConstraint.isActive = true
    }
    
    private func buttonActions() {
        addFeedView.scheduleDropDownView.addTarget(self, action: #selector(dropDownButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors

    @objc func backButtonTapped() {
        
    }
    
    @objc func dropDownButtonTapped() {
        isDropdownVisible.toggle()
        let iconName = isDropdownVisible ? "chevron.up" : "chevron.down"
        addFeedView.dropDownButton.image = UIImage(systemName: iconName)
        
        dropViewHeightConstraint.constant = isDropdownVisible ? LayoutAdapter.shared.scale(value: 356) : LayoutAdapter.shared.scale(value: 50) // 테이블 뷰 포함 높이 조정
        addFeedView.dropDownTableView.isHidden = !isDropdownVisible // 테이블 뷰 표시/숨김 처리
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
