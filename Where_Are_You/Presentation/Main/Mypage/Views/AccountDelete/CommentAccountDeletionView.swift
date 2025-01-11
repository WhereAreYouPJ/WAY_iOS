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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "좋은 추억은 많이 남기셨나요? 😉"
        label.textColor = .black
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 20)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "회원님께서 계정을 삭제하시게 된 이유를 알려주시면, \n귀중한 의견을 반영하여 더욱 노력하겠습니다"
        label.textColor = .color118
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let nextButton = CustomButton(title: "다음", backgroundColor: .color171, titleColor: .white, font: UIFont.pretendard(NotoSans: .bold, fontSize: 18))
    
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
        tableView.register(InputFieldTableViewCell.self, forCellReuseIdentifier: InputFieldTableViewCell.identifier)
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
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 36))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 21))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.leading.equalTo(titleLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 30))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.bottom.equalTo(nextButton.snp.top).inset(LayoutAdapter.shared.scale(value: 20))
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 68))
            make.centerX.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
            make.leading.equalTo(titleLabel)
        }
    }
}
