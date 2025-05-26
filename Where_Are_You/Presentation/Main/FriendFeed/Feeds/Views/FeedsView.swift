//
//  FeedsView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class FeedsView: UIView {
    // MARK: - Properties
    let feedsTableView = UITableView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - helpers
    
    private func configureViewComponents() {
        backgroundColor = .white
        addSubview(feedsTableView)
        feedsTableView.separatorStyle = .none
        feedsTableView.isScrollEnabled = true
    }
    
    private func setupConstraints() {
        feedsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
