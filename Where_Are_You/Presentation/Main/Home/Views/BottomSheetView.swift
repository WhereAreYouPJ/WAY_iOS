//
//  BottomSheetView.swift
//  Where_Are_You
//
//  Created by 오정석 on 22/1/2025.
//

import UIKit
import SnapKit

class BottomSheetView: UIView {
    // MARK: - Properties
    let dateTitle = StandardLabel(UIFont: UIFont.CustomFont.titleH1(text: "t", textColor: .brandDark))
    
    let tableView = UITableView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureTableView()
        setupTableViewHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func setupTableViewHeader() {
        let headerView = UIView()
        headerView.backgroundColor = .brandHighLight1
        headerView.addSubview(dateTitle)
        
        dateTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 28))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8))
        }
        
        headerView.layoutIfNeeded()
        let headerHeight = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        headerView.frame.size.height = headerHeight
        
        tableView.tableHeaderView = headerView
    }
    
    private func configureTableView() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
    }
}
