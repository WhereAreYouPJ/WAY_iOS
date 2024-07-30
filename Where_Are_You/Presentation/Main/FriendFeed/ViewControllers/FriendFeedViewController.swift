//
//  FriendsViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import Foundation
import UIKit

class FriendFeedViewController: UIViewController {
    
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["친구", "피드"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    private let friendsListView = FriendsListView()
    private let feedListView = FeedListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = segmentControl
        let notificationButton = UIBarButtonItem(image: UIImage(named: "icon-bell-notification"), style: .plain, target: self, action: #selector(handleNotification))
        let addButton = UIBarButtonItem(image: UIImage(named: "icon-add"), style: .plain, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItems = [notificationButton, addButton]
    }
    
    private func setupViews() {
        view.addSubview(friendsListView)
        friendsListView.frame = view.bounds
        
        view.addSubview(feedListView)
        feedListView.frame = view.bounds
        feedListView.isHidden = true
    }
    
    @objc private func handleSegmentChange() {
        if segmentControl.selectedSegmentIndex == 0 {
            friendsListView.isHidden = false
            feedListView.isHidden = true
        } else {
            friendsListView.isHidden = true
            feedListView.isHidden = false
        }
    }
    
    @objc private func handleNotification() {
        // 알림 페이지로 이동
    }
    
    @objc private func handleAdd() {
        // 추가 페이지로 이동
    }
}
