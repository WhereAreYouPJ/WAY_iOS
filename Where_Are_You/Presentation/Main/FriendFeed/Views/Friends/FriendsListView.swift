//
//  FriendsListView.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit

class FriendsListView: UIView {
    // MARK: - Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let profileView = ProfileView()
    let favoritesTableView = FavoritesTableView()
    let friendsTableView = FriendsTableView()
    
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
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // 가로 스크롤 방지
        }
        
        profileView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        favoritesTableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        friendsTableView.snp.makeConstraints { make in
            make.top.equalTo(favoritesTableView.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
