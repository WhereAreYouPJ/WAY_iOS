////
////  FriendsTableView.swift
////  Where_Are_You
////
////  Created by 오정석 on 30/7/2024.
////
//
//import UIKit
//import SnapKit
//
//class FriendsTableView: UIView {
//    
//    let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
//        tableView.separatorStyle = .none
//        tableView.isScrollEnabled = false
//        return tableView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupSubviews()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupSubviews() {
//        addSubview(tableView)
//    }
//    
//    private func setupConstraints() {
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//}
