//
//  CommentAccountDeletionView.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/1/2025.
//

import UIKit
import SnapKit

class AccountDeletionReasonView: UIView {
    // MARK: - Properties
    let tableView = UITableView()
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP1(text: "좋은 추억은 많이 남기셨나요? 😉", textColor: .black22))
    
    private let descriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "회원님께서 계정을 삭제하시게 된 이유를 알려주시면, \n귀중한 의견을 반영하여 더욱 노력하겠습니다", textColor: .black66))
    
    let nextButton = TitleButton(title: UIFont.CustomFont.button18(text: "확인", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupTableView() {
        tableView.register(ReasonSelectionTableViewCell.self, forCellReuseIdentifier: ReasonSelectionTableViewCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func configureViewComponents() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(tableView)
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 4))
            make.leading.equalTo(titleLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 24))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(nextButton.snp.top).offset(LayoutAdapter.shared.scale(value: -18))
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
