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
    let tableBackView = UIView()
    let bookMarkTableView = UITableView()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bookMarkTableView, deleteButton])
        stackView.axis = .vertical
        stackView.spacing = LayoutAdapter.shared.scale(value: 24)
        return stackView
    }()
    
    let deleteButton = TitleButton(title: UIFont.CustomFont.button18(text: "삭제하기", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureViewComponents() {
        addSubview(stackView)
        addSubview(editingButton)
    }
    
    func updateDeleteButtonState(isEnabled: Bool) {
        deleteButton.isEnabled = isEnabled
        deleteButton.backgroundColor = isEnabled ? .brandMain : .blackAC // 선택 여부에 따라 색상 변경
    }
    
    private func setupConstraints() {
        editingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.top.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 40))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 180))
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))            
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
