//
//  FriendsViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import Foundation
import UIKit

class FriendFeedViewController: UIViewController {
    // MARK: - Properties
    private let friendsViewController = FriendsListViewController()
    private let feedsViewController = FeedsViewController()
    
    let friend: UIImage = {
        let image = UIImage()
        return image
    }()
    
    let feed: UIImage = {
        let image = UIImage()
        return image
    }()
    
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "피드", at: 0, animated: true)
        sc.insertSegment(withTitle: "친구", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        
        sc.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.color102,
            NSAttributedString.Key.font: UIFont.pretendard(NotoSans: .medium, fontSize: 20)
        ], for: .normal)
        sc.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.color34,
            NSAttributedString.Key.font: UIFont.pretendard(NotoSans: .medium, fontSize: 20)
        ], for: .selected)
        
        sc.selectedSegmentTintColor = .clear
        sc.backgroundColor = .clear
        let image = UIImage()
        sc.setBackgroundImage(image, for: .normal, barMetrics: .default)
        sc.setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        return sc
    }()
    
    let searchFriendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-search"), for: .normal)
        button.tintColor = .brandColor
        return button
    }()
    
    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-notification"), for: .normal)
        button.tintColor = .brandColor
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-plus"), for: .normal)
        button.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 34))
        }
        button.tintColor = .brandColor
        return button
    }()
    
    private lazy var barButtonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchFriendButton, notificationButton, addButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        handleSegmentChange()
        
        segmentControl.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 36)).priority(.required)
        }
    }
    
    // MARK: - Helpers

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentControl)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
    }
   
    private func setupViews() {
        view.backgroundColor = .white
        
        addChild(friendsViewController)
        view.addSubview(friendsViewController.view)
        friendsViewController.didMove(toParent: self)
        friendsViewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        addChild(feedsViewController)
        view.addSubview(feedsViewController.view)
        feedsViewController.didMove(toParent: self)
        
        feedsViewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func handleSegmentChange() {
        if segmentControl.selectedSegmentIndex == 0 {
            showFriendsView()
        } else {
            showFeedsView()
        }
    }
    
    private func showFriendsView() {
        friendsViewController.view.isHidden = false
        feedsViewController.view.isHidden = true
        searchFriendButton.isHidden = false
        notificationButton.isHidden = false
        addButton.isHidden = false
    }
    
    private func showFeedsView() {
        friendsViewController.view.isHidden = true
        feedsViewController.view.isHidden = false
        searchFriendButton.isHidden = true
        notificationButton.isHidden = false
        addButton.isHidden = false
    }
    
    @objc private func handleSearch() {
        // 친구 찾기
    }
    
    @objc private func handleNotification() {
        // 알림 페이지로 이동
    }
    
    @objc private func handleAdd() {
        // 추가 페이지로 이동
    }
}
