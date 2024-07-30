//
//  FriendsListView.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit

class FriendsListView: UIView {
    
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.frame = self.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "favoriteCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "friendCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendsListView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // 즐겨찾기와 친구 섹션
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // 프로필 섹션은 한 개의 셀만
        case 1:
            return 4 // 즐겨찾기 섹션의 셀 수
        case 2:
            return 4 // 친구 섹션의 셀 수
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
            cell.textLabel?.text = "유민혁" // 프로필 이름
            cell.imageView?.image = UIImage(named: "profileImage") // 프로필 이미지
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
            cell.textLabel?.text = "즐겨찾기 \(indexPath.row + 1)"
            cell.imageView?.image = UIImage(named: "favoriteProfileImage")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
            cell.textLabel?.text = "친구 \(indexPath.row + 1)"
            cell.imageView?.image = UIImage(named: "friendProfileImage")
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "내 프로필"
        case 1:
            return "즐겨찾기"
        case 2:
            return "친구"
        default:
            return nil
        }
    }
}
