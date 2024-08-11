//
//  FeedsView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class FeedsView: UIView {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let feedsTableView = UITableView()
    
//    var feeds: [Feed] = [] {
//        didSet {
//            updateFeeds()
//        }
//    }
    
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
        addSubview(scrollView)
        scrollView.addSubview(feedsTableView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        feedsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.top.bottom.equalToSuperview()
        }
    }
    
//    private func updateFeeds() {
//        if feeds.contains(where: { feeds in
//            return feeds.profileImage.isEmpty
//        }) {
//            
//        }
//    }
}
