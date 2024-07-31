//
//  FriendsListViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit
import SnapKit

class FriendsListViewController: UIViewController {
    
    private let friendsListView = FriendsListView()
    private let viewModel = FriendsViewModel()
    
    override func loadView() {
        view = friendsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
    }
    
    private func setupTableView() {
        friendsListView.favoritesTableView.tableView.delegate = self
        friendsListView.favoritesTableView.tableView.dataSource = self
        friendsListView.friendsTableView.tableView.delegate = self
        friendsListView.friendsTableView.tableView.dataSource = self
    }
    
    private func fetchData() {
        viewModel.fetchFriendsData {
            DispatchQueue.main.async {
                self.friendsListView.favoritesTableView.tableView.reloadData()
                self.friendsListView.friendsTableView.tableView.reloadData()
                self.friendsListView.layoutSubviews()
            }
        }
    }
}

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == friendsListView.favoritesTableView.tableView {
            return viewModel.favorites.count
        } else {
            return viewModel.friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == friendsListView.favoritesTableView.tableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as? FriendsTableViewCell else { return UITableViewCell() }
            let favorite = viewModel.favorites[indexPath.row]
            cell.profileImageView.image = UIImage(named: favorite.profileImage)
            cell.nameLabel.text = favorite.name
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.identifier, for: indexPath) as? FriendsTableViewCell else { return UITableViewCell() }
            let friends = viewModel.friends[indexPath.row]
            cell.profileImageView.image = UIImage(named: friends.profileImage)
            cell.nameLabel.text = friends.name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 0.165
    }
}
