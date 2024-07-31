//
//  FriendsListView.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit
import SnapKit

class FriendsListView: UIView {
    // MARK: - Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let profileView = ProfileView()
    let favoritesTableView = FavoritesTableView()
    let friendsTableView = FriendsTableView()
    
    private var favoritesTableViewHeightConstraint: Constraint?
    private var friendsTableViewHeightConstraint: Constraint?

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        contentView.addSubview(profileView)
        contentView.addSubview(favoritesTableView)
        contentView.addSubview(friendsTableView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide) // 가로 스크롤 방지
        }
        
        profileView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(0.213)
        }
        
        favoritesTableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            favoritesTableViewHeightConstraint = make.height.equalTo(0).constraint // 초기 높이를 0으로 설정
        }
        
        friendsTableView.snp.makeConstraints { make in
            make.top.equalTo(favoritesTableView.snp.bottom).offset(19)
            make.leading.trailing.bottom.equalToSuperview()
            friendsTableViewHeightConstraint = make.height.equalTo(0).constraint // 초기 높이를 0으로 설정
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 동적 높이 계산 후 제약 조건 업데이트
        favoritesTableViewHeightConstraint?.update(offset: favoritesTableView.tableView.contentSize.height)
        friendsTableViewHeightConstraint?.update(offset: friendsTableView.tableView.contentSize.height)
    }
}
