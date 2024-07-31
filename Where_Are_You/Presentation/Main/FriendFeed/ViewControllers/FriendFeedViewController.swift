//
//  FriendsViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import Foundation
import UIKit

class FriendFeedViewController: UIViewController {
    
    private lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["친구", "피드"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    private let friendsViewController = FriendsListViewController()
    //    private let feedsViewController = FeedsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        handleSegmentChange()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentControl)
        let notificationButton = UIBarButtonItem(image: UIImage(named: "icon-notification"), style: .plain, target: self, action: #selector(handleNotification))
        let addButton = UIBarButtonItem(image: UIImage(named: "icon-plus"), style: .plain, target: self, action: #selector(handleAdd))
                navigationItem.rightBarButtonItems = [notificationButton, addButton]
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        addChild(friendsViewController)
        view.addSubview(friendsViewController.view)
        friendsViewController.didMove(toParent: self)
        
        friendsViewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        //        addChild(feedsViewController)
        //        view.addSubview(feedsViewController.view)
        //        feedsViewController.didMove(toParent: self)
        
        //        feedsViewController.view.snp.makeConstraints { make in
        //            make.top.equalToSuperview().offset(8)
        //            make.leading.trailing.bottom.equalToSuperview()
        //        }
    }
    
    @objc private func handleSegmentChange() {
        if segmentControl.selectedSegmentIndex == 0 {
            showFriendsView()
        } else {
            showFriendsView()
            
            //            showFeedsView()
        }
    }
    
    private func showFriendsView() {
        friendsViewController.view.isHidden = false
        //        feedsViewController.view.isHidden = true
        navigationItem.rightBarButtonItems?.last?.isHidden = false // Show the add button
        navigationItem.rightBarButtonItems?.first?.isHidden = false // Show the notification button
    }
    
    //    private func showFeedsView() {
    //        friendsViewController.view.isHidden = true
    //        feedsViewController.view.isHidden = false
    //        navigationItem.rightBarButtonItems?.last?.isHidden = false // Show the add button
    //        navigationItem.rightBarButtonItems?.first?.isHidden = true // Hide the notification button
    //    }
    
    @objc private func handleNotification() {
        // 알림 페이지로 이동
    }
    
    @objc private func handleAdd() {
        // 추가 페이지로 이동
    }
}
