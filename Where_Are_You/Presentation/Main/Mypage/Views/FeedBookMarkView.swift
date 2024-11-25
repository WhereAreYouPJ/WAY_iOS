//
//  FeedBookMarkView.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import UIKit

class FeedBookMarkView: UIView {
    // MARK: - Properties
    let scrollView = UIScrollView()
    let contentView = UIView()
    let feedsBookMarkTableView = UITableView()
    
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
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(feedsBookMarkTableView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        feedsBookMarkTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.top.bottom.equalToSuperview()
        }
    }
}
