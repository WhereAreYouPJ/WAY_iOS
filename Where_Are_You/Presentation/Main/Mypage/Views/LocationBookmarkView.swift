//
//  LocationBookmarkView.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/8/2024.
//

import UIKit

class LocationBookmarkView: UIView {
    // MARK: - Properties
    let editingButton = CustomOptionButtonView(title: "위치 삭제")
    let bookMarkTableView = UITableView()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bookMarkTableView, deleteButton])
        stackView.axis = .vertical
        stackView.spacing = LayoutAdapter.shared.scale(value: 24)
        return stackView
    }()
    
    let deleteButton = CustomButton(title: "삭제하기", backgroundColor: .color171, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 18)))

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupUI() {
        editingButton.isHidden = true
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
    }
    
    private func configureViewComponents() {
        addSubview(editingButton)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        editingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: -3))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 38))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 160))
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
            make.bottom.equalTo(safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 20))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
    }
}
